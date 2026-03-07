import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';
import '../models/difficulty_model.dart';
import '../theme/app_theme.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final QuizCategory category;
  final List<QuizQuestion> questions;
  final DifficultyLevel difficulty;

  const QuizPage({
    super.key,
    required this.category,
    required this.questions,
    this.difficulty = DifficultyLevel.medium,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _answered = false;
  bool _paused = false;
  final List<Mistake> _mistakes = [];
  late int _remainingSeconds;
  Timer? _timer;
  final DateTime _startTime = DateTime.now();

  // Animation controllers
  late AnimationController _questionController;
  late Animation<double> _questionOpacity;
  late Animation<Offset> _questionSlide;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackOpacity;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _correctController;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.difficulty.durationSeconds;
    _setupAnimations();
    _startTimer();
    _animateQuestion();
  }

  void _setupAnimations() {
    _questionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _questionOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(_questionController);
    _questionSlide =
        Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.easeOut),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(_feedbackController);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(_shakeController);

    _correctController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    Tween<double>(begin: 1.0, end: 1.05)
        .animate(CurvedAnimation(parent: _correctController, curve: Curves.easeOut));
  }

  void _animateQuestion() {
    _questionController.forward(from: 0);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_paused) return;
      setState(() => _remainingSeconds--);
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _finishQuiz();
      }
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
    if (_paused) {
      HapticFeedback.lightImpact();
    }
  }

  void _selectOption(String option) {
    if (_answered) return;

    final currentQuestion = widget.questions[_currentIndex];
    final isCorrect = option == currentQuestion.answer;

    setState(() {
      _selectedOption = option;
      _answered = true;
    });

    _feedbackController.forward(from: 0);

    if (isCorrect) {
      _score++;
      HapticFeedback.lightImpact();
      _correctController.forward(from: 0).then((_) {
        _correctController.reverse();
      });
    } else {
      HapticFeedback.mediumImpact();
      _shakeController.forward(from: 0);
      _mistakes.add(Mistake(
        sessionId: 0,
        question: currentQuestion.question,
        userChoice: option,
        correctAnswer: currentQuestion.answer,
        hint: currentQuestion.hint,
      ));
    }

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_currentIndex < widget.questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _answered = false;
        });
        _feedbackController.reset();
        _animateQuestion();
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    _timer?.cancel();
    final durationSecs =
        DateTime.now().difference(_startTime).inSeconds;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultPage(
          category: widget.category,
          score: _score,
          total: widget.questions.length,
          mistakes: _mistakes,
          durationSeconds: durationSecs,
          difficulty: widget.difficulty,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionController.dispose();
    _feedbackController.dispose();
    _shakeController.dispose();
    _correctController.dispose();
    super.dispose();
  }

  String get _timeString {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color get _timerColor {
    if (_remainingSeconds > 120) return AppColors.sageGreen;
    if (_remainingSeconds > 60) return AppColors.timerOrange;
    return AppColors.wrongRed;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final isCorrect = _answered && _selectedOption == question.answer;
    final isWrong = _answered && _selectedOption != question.answer;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
        child: Scaffold(
        backgroundColor: () {
          if (isCorrect) {
            return AppColors.correctGreenLight.withValues(alpha: 
                _feedbackOpacity.value * 0.3 + 0.7);
          }
          if (isWrong) {
            return AppColors.wrongRedLight.withValues(alpha: 
                _feedbackOpacity.value * 0.3 + 0.7);
          }
          return AppColors.background;
        }(),
        body: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _feedbackController,
                builder: (context, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: isCorrect
                        ? AppColors.correctGreenLight.withValues(alpha: 
                            _feedbackOpacity.value * 0.25)
                        : isWrong
                            ? AppColors.wrongRedLight.withValues(alpha: 
                                _feedbackOpacity.value * 0.25)
                            : Colors.transparent,
                    child: Column(
                      children: [
                        _buildTopBar(),
                        _buildProgressBar(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                _buildQuestionCard(question),
                                const SizedBox(height: 20),
                                ..._buildOptions(question),
                                const SizedBox(height: 20),
                                if (_answered) _buildFeedbackBanner(isCorrect, question),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (_paused) _buildPauseOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showExitDialog(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.close_rounded,
                  color: AppColors.textDark, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${widget.difficulty.emoji} ${widget.difficulty.label}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          // Pause button
          GestureDetector(
            onTap: _togglePause,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: Icon(
                _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: AppColors.textDark,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Timer
          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, _) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _timerColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _timerColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: _timerColor),
                    const SizedBox(width: 4),
                    Text(
                      _timeString,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _timerColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentIndex + 1) / widget.questions.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.paleSageGreen,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${_currentIndex + 1}/${widget.questions.length}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question) {
    return SlideTransition(
      position: _questionSlide,
      child: FadeTransition(
        opacity: _questionOpacity,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.paleSageGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Soru ${_currentIndex + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptions(QuizQuestion question) {
    return question.options.asMap().entries.map((entry) {
      final option = entry.value;
      final isSelected = _selectedOption == option;
      final isCorrectOption = option == question.answer;

      Color bgColor = AppColors.cardWhite;
      Color borderColor = Colors.transparent;
      Color textColor = AppColors.textDark;
      Widget? trailingIcon;

      if (_answered) {
        if (isCorrectOption) {
          bgColor = AppColors.correctGreenLight;
          borderColor = AppColors.correctGreen;
          textColor = AppColors.correctGreen;
          trailingIcon = const Icon(Icons.check_circle_rounded,
              color: AppColors.correctGreen, size: 20);
        } else if (isSelected && !isCorrectOption) {
          bgColor = AppColors.wrongRedLight;
          borderColor = AppColors.wrongRed;
          textColor = AppColors.wrongRed;
          trailingIcon = const Icon(Icons.cancel_rounded,
              color: AppColors.wrongRed, size: 20);
        }
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () => _selectOption(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor == Colors.transparent
                    ? AppColors.shadow
                    : borderColor,
                width: borderColor == Colors.transparent ? 1 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: isSelected || (isCorrectOption && _answered)
                          ? FontWeight.w600
                          : FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                if (trailingIcon != null) trailingIcon,
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildFeedbackBanner(bool isCorrect, QuizQuestion question) {
    return FadeTransition(
      opacity: _feedbackOpacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.correctGreenLight : AppColors.wrongRedLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCorrect
                ? AppColors.correctGreen.withValues(alpha: 0.3)
                : AppColors.wrongRed.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCorrect ? '🌟' : '💡', style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCorrect ? 'Harika! Doğru cevap!' : 'Neredeyse...',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isCorrect ? AppColors.correctGreen : AppColors.wrongRed,
                      fontSize: 14,
                    ),
                  ),
                  if (!isCorrect) ...[
                    const SizedBox(height: 4),
                    Text(
                      question.hint,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏸️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text(
                'Test Duraklatıldı',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hazır olduğunda devam et',
                style: TextStyle(fontSize: 14, color: AppColors.textMedium),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _togglePause,
                  child: const Text('Devam Et'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() => _paused = false);
                  _showExitDialog();
                },
                child: const Text(
                  'Testi Bırak',
                  style: TextStyle(color: AppColors.wrongRed),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Testi Bırak?'),
        content: const Text(
          'Mevcut ilerlemeniz kaydedilmeyecek. Çıkmak istediğinizden emin misiniz?',
          style: TextStyle(color: AppColors.textMedium, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Devam Et',
                style: TextStyle(color: AppColors.sageGreen)),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Çık',
                style: TextStyle(color: AppColors.wrongRed)),
          ),
        ],
      ),
    );
  }
}
