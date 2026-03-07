import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/study_content.dart';
import '../models/question_model.dart';
import '../services/gamification_service.dart';
import '../theme/app_theme.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int _categoryIndex = 0;
  List<_Flashcard> _cards = [];
  int _currentCard = 0;
  bool _flipped = false;

  static const List<String> _categoryKeys = ['physics', 'chemistry', 'biology', 'cs', 'english', 'math', 'turkish', 'history'];

  @override
  void initState() {
    super.initState();
    _buildCards();
    GamificationService().onFlashcardOpened();
  }

  void _buildCards() {
    final key = _categoryKeys[_categoryIndex];
    final topics = StudyContent.content[key] ?? [];
    final List<_Flashcard> cards = [];

    for (final topic in topics) {
      for (final section in topic.sections) {
        for (final kp in section.keyPoints) {
          cards.add(_parseKeyPoint(kp, section.heading, topic.emoji));
        }
      }
    }

    cards.shuffle(Random());
    setState(() {
      _cards = cards.take(30).toList();
      _currentCard = 0;
      _flipped = false;
    });
  }

  /// Key point'i soru-cevap kartına dönüştürür.
  /// "X → Y" → Soru: "X nedir?", Cevap: Y
  /// "X: Y"  → Soru: "X nedir?", Cevap: Y
  /// Tam cümle → Soru: "Bu bilgi doğru mu?", Cevap: onay
  _Flashcard _parseKeyPoint(String kp, String heading, String emoji) {
    String question;
    String answer;

    if (kp.contains('→')) {
      final idx = kp.indexOf('→');
      final left = kp.substring(0, idx).trim();
      final right = kp.substring(idx + 1).trim();
      // "1. Yasa → Eylemsizlik ilkesi" → "Newton'un 1. Yasası nedir?"
      question = '$emoji $left nedir?';
      answer = right;
    } else if (kp.contains(':')) {
      final idx = kp.indexOf(':');
      final concept = kp.substring(0, idx).trim();
      final explanation = kp.substring(idx + 1).trim();
      question = '$emoji $concept nedir?';
      answer = explanation;
    } else {
      // Tam cümle — "Bu doğru mu?" sorusu yap
      question = '$emoji Doğru mu?\n"$kp"';
      answer = '✅ Evet, bu bilgi doğrudur!\n\nKonu: $heading';
    }

    return _Flashcard(front: question, back: answer, keyPoints: const []);
  }

  void _flip() {
    HapticFeedback.lightImpact();
    setState(() => _flipped = !_flipped);
  }

  void _next() {
    if (_currentCard < _cards.length - 1) {
      setState(() {
        _currentCard++;
        _flipped = false;
      });
    }
  }

  void _prev() {
    if (_currentCard > 0) {
      setState(() {
        _currentCard--;
        _flipped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.background;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Flashcard Modu', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryTabs(isDark, textPrimary),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kart ${_currentCard + 1} / ${_cards.length}',
                  style: TextStyle(fontSize: 13, color: textPrimary, fontWeight: FontWeight.w600),
                ),
                Text(
                  _flipped ? 'Kartı çevir →' : '← Kartı çevir',
                  style: const TextStyle(fontSize: 12, color: AppColors.sageGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GestureDetector(
              onTap: _flip,
              onHorizontalDragEnd: (d) {
                if (d.primaryVelocity != null && d.primaryVelocity! < -300) _next();
                if (d.primaryVelocity != null && d.primaryVelocity! > 300) _prev();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _cards.isEmpty
                    ? const Center(child: Text('Kart bulunamadı'))
                    : _FlipCard(
                        card: _cards[_currentCard],
                        flipped: _flipped,
                        isDark: isDark,
                      ),
              ),
            ),
          ),
          _buildNavButtons(isDark, textPrimary),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(bool isDark, Color textPrimary) {
    final tabLabels = QuizCategory.all.map((c) => c.emoji).toList();
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tabLabels.length,
        itemBuilder: (context, index) {
          final selected = index == _categoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _categoryIndex = index);
              _buildCards();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.sageGreen
                    : (isDark ? AppColors.darkCard : AppColors.cardWhite),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: Row(
                children: [
                  Text(tabLabels[index], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  Text(
                    QuizCategory.all[index].name.split(' ').first,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButtons(bool isDark, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentCard > 0 ? _prev : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Önceki'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.sageGreen),
                foregroundColor: AppColors.sageGreen,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentCard < _cards.length - 1 ? _next : null,
              icon: const Text('Sonraki'),
              label: const Icon(Icons.arrow_forward_rounded, size: 16),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Flashcard {
  final String front;
  final String back;
  final List<String> keyPoints;
  const _Flashcard({required this.front, required this.back, required this.keyPoints});
}

class _FlipCard extends StatefulWidget {
  final _Flashcard card;
  final bool flipped;
  final bool isDark;

  const _FlipCard({required this.card, required this.flipped, required this.isDark});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_FlipCard old) {
    super.didUpdateWidget(old);
    if (widget.flipped != old.flipped) {
      if (widget.flipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (widget.card != old.card) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final isShowingBack = _anim.value >= 0.5;
        final angle = _anim.value * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isShowingBack
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildCardFace(
                    isBack: true,
                    isDark: widget.isDark,
                    card: widget.card,
                  ),
                )
              : _buildCardFace(isBack: false, isDark: widget.isDark, card: widget.card),
        );
      },
    );
  }

  Widget _buildCardFace({required bool isBack, required bool isDark, required _Flashcard card}) {
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardWhite;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textMedium;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isBack
            ? (isDark ? const Color(0xFF1E2E20) : AppColors.paleSageGreen)
            : cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isBack
              ? AppColors.sageGreen.withValues(alpha: 0.3)
              : AppColors.shadow,
          width: isBack ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isBack
                  ? AppColors.sageGreen.withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkSurface : AppColors.paleSoftBlue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isBack ? 'CEVAP' : 'SORU',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isBack ? AppColors.sageGreen : AppColors.softBlue,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isBack ? card.back : card.front,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isBack ? 15 : 18,
              fontWeight: isBack ? FontWeight.w400 : FontWeight.w700,
              color: isBack ? textSecondary : textPrimary,
              height: 1.6,
            ),
          ),
          if (isBack && card.keyPoints.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            ...card.keyPoints.take(2).map((kp) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.sageGreen, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(kp,
                        style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4)),
                  ),
                ],
              ),
            )),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, size: 14, color: textSecondary),
              const SizedBox(width: 4),
              Text(
                'Çevirmek için dokun',
                style: TextStyle(fontSize: 11, color: textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
