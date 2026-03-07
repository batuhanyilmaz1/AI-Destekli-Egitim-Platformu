import 'package:flutter/material.dart';
import '../../models/gamification_model.dart';
import '../../services/database_service.dart';
import '../../services/badge_notification_service.dart';
import '../../theme/app_theme.dart';

class BadgePage extends StatefulWidget {
  const BadgePage({super.key});

  @override
  State<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  Set<String> _unlocked = {};
  Set<String> _unseen = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait<Set<String>>([
      DatabaseService().getAwardedBadgeIds(),
      BadgeNotificationService.getUnseenBadgeIds(),
    ]);
    if (mounted) {
      setState(() {
        _unlocked = results[0];
        _unseen = results[1];
        _loading = false;
      });
    }
  }

  Future<void> _onBadgeRevealed(String badgeId) async {
    await BadgeNotificationService.markAsSeen(badgeId);
    if (mounted) {
      setState(() => _unseen.remove(badgeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.background;
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardWhite;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textDark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textMedium;

    final unlockedCount = _unlocked.length;
    final total = BadgeInfo.all.length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'Rozetler',
          style:
              TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.sageGreen))
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF5C242), Color(0xFFE8A45A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF5C242).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Rozet Koleksiyonu',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$unlockedCount / $total kazanıldı'
                                '${_unseen.isNotEmpty ? ' · ${_unseen.length} yeni!' : ''}',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: total > 0
                                      ? unlockedCount / total
                                      : 0,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.3),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_unseen.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF3C0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFF5C242)
                                .withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Text('✨',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${_unseen.length} yeni rozet kazandın! Rozetlere tıklayarak aç.',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8A6D00),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: BadgeInfo.all.length,
                    itemBuilder: (context, index) {
                      final badge = BadgeInfo.all[index];
                      final isUnlocked =
                          _unlocked.contains(badge.id.name);
                      final isNew = _unseen.contains(badge.id.name);
                      return _BadgeCard(
                        badge: badge,
                        isUnlocked: isUnlocked,
                        isNew: isNew,
                        cardColor: cardColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        isDark: isDark,
                        onRevealed: isNew
                            ? () => _onBadgeRevealed(badge.id.name)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ─── Rozet Kartı (animasyonlu) ───

class _BadgeCard extends StatefulWidget {
  final BadgeInfo badge;
  final bool isUnlocked;
  final bool isNew;
  final Color cardColor;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;
  final VoidCallback? onRevealed;

  const _BadgeCard({
    required this.badge,
    required this.isUnlocked,
    required this.isNew,
    required this.cardColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
    this.onRevealed,
  });

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowOpacity;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.18)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.18, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
    ]).animate(_glowController);
    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 30),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 70),
    ]).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.isNew && !_revealed) {
      setState(() => _revealed = true);
      await _glowController.forward();
      widget.onRevealed?.call();
    } else {
      _showDetail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.isNew && !_revealed;

    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  // Ana kart içeriği — tüm alanı doldurur
                  child!,
                  // Altın parlama katmanı
                  if (_glowController.isAnimating ||
                      _glowController.isCompleted)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: _glowOpacity.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF5C242)
                                      .withValues(alpha: 0.8),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFFFF9C4)
                                      .withValues(alpha: 0.9),
                                  const Color(0xFFF5C242)
                                      .withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // "YENİ" etiketi
                  if (isNew)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5C242),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF5C242)
                                  .withValues(alpha: 0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Text(
                          'YENİ',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          child: _buildCardContent(isNew),
        ),
      ),
    );
  }

  Widget _buildCardContent(bool isNew) {
    final isUnlocked = widget.isUnlocked;
    // Yeni rozetler tıklanana kadar kilitli görünür
    final showLocked = !isUnlocked || isNew;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: isNew
            ? Border.all(
                color: const Color(0xFFF5C242).withValues(alpha: 0.8),
                width: 2)
            : !showLocked
                ? Border.all(
                    color: const Color(0xFFF5C242).withValues(alpha: 0.4),
                    width: 1.5)
                : null,
        boxShadow: [
          BoxShadow(
            color: isNew
                ? const Color(0xFFF5C242).withValues(alpha: 0.3)
                : !showLocked
                    ? const Color(0xFFF5C242).withValues(alpha: 0.12)
                    : AppColors.shadow,
            blurRadius: isNew ? 16 : !showLocked ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
        child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 58,
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: showLocked
                          ? (widget.isDark
                              ? AppColors.darkSurface
                              : const Color(0xFFF0F0F0))
                          : const Color(0xFFFDF3C0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        showLocked ? '🔒' : widget.badge.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  if (!showLocked)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.correctGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            size: 11, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 16,
              child: Text(
                widget.badge.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color:
                      showLocked ? widget.textSecondary : widget.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 14,
              child: Text(
                isNew
                    ? '✨ Tıkla & Aç!'
                    : !showLocked
                        ? 'Kazanıldı ✓'
                        : 'Kilitli',
                style: TextStyle(
                  fontSize: 10,
                  color: isNew
                      ? const Color(0xFFB8860B)
                      : !showLocked
                          ? AppColors.correctGreen
                          : widget.textSecondary,
                  fontWeight: isNew ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnlocked = widget.isUnlocked;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? const Color(0xFFFDF3C0)
                    : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isUnlocked ? widget.badge.emoji : '🔒',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.badge.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.badge.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textMedium,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.correctGreenLight
                    : (isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF0F0F0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isUnlocked
                    ? '✅ Rozet Kazanıldı!'
                    : '🔒 Henüz Kazanılmadı',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? AppColors.correctGreen
                      : AppColors.textLight,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
