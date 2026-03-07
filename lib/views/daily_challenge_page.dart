import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/difficulty_model.dart';
import '../models/gamification_model.dart';
import '../services/gemini_service.dart';
import '../services/gamification_service.dart';
import '../theme/app_theme.dart';

class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({super.key});

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  String? _error;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const List<_ChallengeOption> _options = [
    _ChallengeOption('⚛️', 'Fen', 'Fizik, Kimya veya Biyoloji', 'science'),
    _ChallengeOption('💻', 'Bilgisayar', 'Algoritmalar & Kodlama', 'cs'),
    _ChallengeOption('🌍', 'Karma', 'Tüm kategorilerden karma 5 soru', 'mixed'),
  ];

  Future<void> _startChallenge(String type) async {
    setState(() { _loading = true; _error = null; });

    try {
      String category;
      QuizCategory cat;

      if (type == 'mixed') {
        final all = QuizCategory.all;
        all.shuffle();
        cat = all.first;
        category = cat.name;
      } else if (type == 'science') {
        const scienceCats = ['Fizik', 'Kimya', 'Biyoloji'];
        final allCats = QuizCategory.all;
        final matched = allCats.where((c) => scienceCats.any((s) => c.name.contains(s))).toList();
        cat = matched.isNotEmpty ? matched.first : allCats.first;
        category = cat.name;
      } else {
        final allCats = QuizCategory.all;
        final matched = allCats.where((c) => c.name.contains('Bilgisayar')).toList();
        cat = matched.isNotEmpty ? matched.first : allCats.first;
        category = cat.name;
      }

      final service = GeminiService();
      final questions = await service.generateQuestions(
        category,
        difficulty: DifficultyLevel.medium,
        count: 5,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => _ChallengeQuizPage(
            category: cat,
            questions: questions,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.background;
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardWhite;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textMedium;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Günlük Görev', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 50, height: 50,
                    child: CircularProgressIndicator(color: AppColors.timerOrange, strokeWidth: 3),
                  ),
                  const SizedBox(height: 16),
                  Text('Sorular hazırlanıyor...', style: TextStyle(fontSize: 15, color: textSecondary)),
                ],
              ),
            )
          : ScaleTransition(
              scale: _scaleAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8A45A), Color(0xFFE8735A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.timerOrange.withValues(alpha: 0.35),
                            blurRadius: 20, offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text('🎯', style: TextStyle(fontSize: 56)),
                          const SizedBox(height: 12),
                          const Text(
                            'Günlük Görev',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '5 soru · Zaman sınırsız · Ekstra XP',
                            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _infoPill('⭐ Bonus XP'),
                              const SizedBox(width: 8),
                              _infoPill('⏰ Süresiz'),
                              const SizedBox(width: 8),
                              _infoPill('🎯 5 Soru'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Konu Seç',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.wrongRedLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.wrongRed.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Text('⚠️', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(_error!, style: const TextStyle(fontSize: 13, color: AppColors.wrongRed, height: 1.4)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    ..._options.map((option) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ChallengeOptionCard(
                        option: option,
                        onTap: () => _startChallenge(option.type),
                        cardColor: cardColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    )),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _infoPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}

class _ChallengeOption {
  final String emoji;
  final String title;
  final String subtitle;
  final String type;
  const _ChallengeOption(this.emoji, this.title, this.subtitle, this.type);
}

class _ChallengeOptionCard extends StatelessWidget {
  final _ChallengeOption option;
  final VoidCallback onTap;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;

  const _ChallengeOptionCard({
    required this.option,
    required this.onTap,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: AppColors.lightPaleYellow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text(option.emoji, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 2),
                  Text(option.subtitle, style: TextStyle(fontSize: 12, color: textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.timerOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: AppColors.timerOrange, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mini Quiz Page for the challenge ───

class _ChallengeQuizPage extends StatefulWidget {
  final QuizCategory category;
  final List<QuizQuestion> questions;

  const _ChallengeQuizPage({required this.category, required this.questions});

  @override
  State<_ChallengeQuizPage> createState() => _ChallengeQuizPageState();
}

class _ChallengeQuizPageState extends State<_ChallengeQuizPage> {
  int _current = 0;
  int _score = 0;
  String? _selected;
  bool _answered = false;
  bool _finished = false;

  void _select(String option) {
    if (_answered) return;
    final isCorrect = option == widget.questions[_current].answer;
    setState(() {
      _selected = option;
      _answered = true;
      if (isCorrect) _score++;
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      if (_current < widget.questions.length - 1) {
        setState(() {
          _current++;
          _selected = null;
          _answered = false;
        });
      } else {
        _finishChallenge();
      }
    });
  }

  Future<void> _finishChallenge() async {
    try {
      await GamificationService().onQuizComplete(
        category: widget.category.name,
        score: _score,
        total: widget.questions.length,
        difficultyLabel: 'Orta',
        isChallenge: true,
      );
    } catch (_) {}
    if (mounted) setState(() => _finished = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.background;
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardWhite;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textMedium;

    if (_finished) return _buildResult(bgColor, cardColor, textPrimary, textSecondary);

    final q = widget.questions[_current];
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Günlük Görev', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_current + 1}/${widget.questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.sageGreen),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_current + 1) / widget.questions.length,
                backgroundColor: isDark ? AppColors.darkSurface : AppColors.paleSageGreen,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.timerOrange),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Text(
                q.question,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: q.options.map((option) {
              final isSelected = _selected == option;
              final isCorrect = option == q.answer;
              Color bg = cardColor;
              Color border = Colors.transparent;
              if (_answered) {
                if (isCorrect) { bg = AppColors.correctGreenLight; border = AppColors.correctGreen; }
                else if (isSelected) { bg = AppColors.wrongRedLight; border = AppColors.wrongRed; }
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => _select(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border == Colors.transparent ? AppColors.shadow : border, width: border == Colors.transparent ? 1 : 1.5),
                      boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 15,
                        color: _answered && isCorrect ? AppColors.correctGreen : _answered && isSelected ? AppColors.wrongRed : textPrimary,
                        fontWeight: isSelected || (_answered && isCorrect) ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(Color bgColor, Color cardColor, Color textPrimary, Color textSecondary) {
    final xpEarned = XPLevel.calculateEarned(_score, widget.questions.length, 'Orta');
    final pct = (_score / widget.questions.length * 100).round();
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(pct >= 80 ? '🏆' : pct >= 60 ? '🌟' : '📚', style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                '$_score/${widget.questions.length}',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                pct >= 80 ? 'Harika! Günlük görev tamamlandı!' : 'Günlük görev tamamlandı!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.timerOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.timerOrange.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '⭐ +$xpEarned XP kazandın!',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.timerOrange),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.timerOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Ana Sayfaya Dön', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
