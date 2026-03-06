import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';
import '../models/difficulty_model.dart';
import '../services/database_service.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';

class ResultPage extends StatefulWidget {
  final QuizCategory category;
  final int score;
  final int total;
  final List<Mistake> mistakes;
  final int durationSeconds;
  final DifficultyLevel difficulty;

  const ResultPage({
    super.key,
    required this.category,
    required this.score,
    required this.total,
    required this.mistakes,
    required this.durationSeconds,
    this.difficulty = DifficultyLevel.medium,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late Animation<double> _scoreScale;
  late AnimationController _contentController;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  String? _mentorFeedback;
  bool _loadingFeedback = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _saveSession();
    _loadMentorFeedback();
  }

  void _setupAnimations() {
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scoreScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.elasticOut),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _scoreController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentController.forward();
    });
  }

  Future<void> _saveSession() async {
    try {
      final db = DatabaseService();
      final session = QuizSession(
        category: widget.category.name,
        score: widget.score,
        totalQuestions: widget.total,
        date: DateTime.now(),
        durationSeconds: widget.durationSeconds,
      );
      final id = await db.insertSession(session);

      if (widget.mistakes.isNotEmpty) {
        final mistakesWithId = widget.mistakes
            .map((m) => Mistake(
                  sessionId: id,
                  question: m.question,
                  userChoice: m.userChoice,
                  correctAnswer: m.correctAnswer,
                  hint: m.hint,
                ))
            .toList();
        await db.insertMistakes(mistakesWithId);
      }
    } catch (_) {}
  }

  Future<void> _loadMentorFeedback() async {
    try {
      final service = GeminiService();
      final feedback = await service.analyzeMistakes(
        widget.category.name,
        widget.mistakes,
        score: widget.score,
        total: widget.total,
      );
      if (mounted) {
        setState(() {
          _mentorFeedback = feedback;
          _loadingFeedback = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _mentorFeedback = 'Mentor analizi şu an yüklenemiyor. 😊';
          _loadingFeedback = false;
        });
      }
    }
  }

  double get _percentage => widget.score / widget.total;

  String get _gradeEmoji {
    if (_percentage >= 0.9) return '🏆';
    if (_percentage >= 0.7) return '🌟';
    if (_percentage >= 0.5) return '👍';
    return '📚';
  }

  String get _gradeText {
    if (_percentage >= 0.9) return 'Mükemmel!';
    if (_percentage >= 0.7) return 'Harika İş!';
    if (_percentage >= 0.5) return 'İyi Gidiyorsun!';
    return 'Daha Fazla Çalış!';
  }

  Color get _gradeColor {
    if (_percentage >= 0.7) return AppColors.correctGreen;
    if (_percentage >= 0.5) return AppColors.timerOrange;
    return AppColors.wrongRed;
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}dk ${s}sn';
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildScoreCard(),
              SlideTransition(
                position: _contentSlide,
                child: FadeTransition(
                  opacity: _contentOpacity,
                  child: Column(
                    children: [
                      _buildStatsRow(),
                      _buildMentorCard(),
                      if (widget.mistakes.isNotEmpty)
                        _buildMistakesList(),
                      _buildActionButtons(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            ),
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
              child: const Icon(Icons.home_rounded,
                  color: AppColors.textDark, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Test Sonucu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _gradeColor.withValues(alpha: 0.8),
              _gradeColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _gradeColor.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              _gradeEmoji,
              style: const TextStyle(fontSize: 44),
            ),
            const SizedBox(height: 8),
            ScaleTransition(
              scale: _scoreScale,
              child: Text(
                '${widget.score}/${widget.total}',
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _gradeText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.category.name,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.difficulty.emoji} ${widget.difficulty.label} · ${widget.difficulty.durationLabel}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              emoji: '✅',
              label: 'Doğru',
              value: widget.score.toString(),
              color: AppColors.correctGreen,
              bgColor: AppColors.correctGreenLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              emoji: '❌',
              label: 'Yanlış',
              value: widget.mistakes.length.toString(),
              color: AppColors.wrongRed,
              bgColor: AppColors.wrongRedLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              emoji: '⏱️',
              label: 'Süre',
              value: _formatDuration(widget.durationSeconds),
              color: AppColors.softBlue,
              bgColor: AppColors.paleSoftBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.paleSageGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('🤖', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Mentor Analizi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Gemini AI tarafından oluşturuldu',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.paleSageGreen),
            const SizedBox(height: 12),
            if (_loadingFeedback)
              const Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.sageGreen,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mentor analiz ediyor...',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textMedium),
                    ),
                  ],
                ),
              )
            else
              Text(
                _mentorFeedback ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                  height: 1.6,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMistakesList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yanlış Cevaplar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          ...widget.mistakes.asMap().entries.map((entry) {
            final idx = entry.key;
            final m = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.wrongRed.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.wrongRedLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${idx + 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.wrongRed,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          m.question,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _AnswerRow(
                      label: 'Senin cevabın',
                      value: m.userChoice,
                      isCorrect: false),
                  const SizedBox(height: 4),
                  _AnswerRow(
                      label: 'Doğru cevap',
                      value: m.correctAnswer,
                      isCorrect: true),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Yeniden Dene',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              ),
              style: OutlinedButton.styleFrom(
                side:
                    const BorderSide(color: AppColors.sageGreen, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Ana Menüye Dön',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sageGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isCorrect;

  const _AnswerRow({
    required this.label,
    required this.value,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCorrect
              ? Icons.check_circle_rounded
              : Icons.cancel_rounded,
          size: 14,
          color: isCorrect ? AppColors.correctGreen : AppColors.wrongRed,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCorrect
                        ? AppColors.correctGreen
                        : AppColors.wrongRed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
