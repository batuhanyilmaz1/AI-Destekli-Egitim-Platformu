import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/gamification_model.dart';
import '../services/gamification_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import 'history_page.dart';
import 'flashcard_page.dart';
import 'daily_challenge_page.dart';
import 'profile/badge_page.dart';
import 'profile/chart_page.dart';
// ignore: unused_import
import '../services/badge_notification_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _profile;
  Map<String, dynamic> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final svc = GamificationService();
      final db = DatabaseService();
      final profile = await svc.getProfile();
      final stats = await db.getStats();
      if (mounted) {
        setState(() {
          _profile = profile;
          _stats = stats;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    themeModeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
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
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.sageGreen))
            : RefreshIndicator(
                color: AppColors.sageGreen,
                onRefresh: _loadData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    _buildPageHeader(textPrimary),
                    const SizedBox(height: 20),
                    _buildProfileCard(cardColor, isDark),
                    const SizedBox(height: 20),
                    _buildSectionLabel('İstatistikler', textSecondary),
                    const SizedBox(height: 10),
                    _buildStatsRow(cardColor, textPrimary, textSecondary),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Özellikler', textSecondary),
                    const SizedBox(height: 10),
                    _buildFeatureCard(
                      emoji: '🏆',
                      title: 'Rozetlerim',
                      subtitle: '${_profile?.unlockedBadgeIds.length ?? 0}/${BadgeInfo.all.length} rozet kazanıldı',
                      color: const Color(0xFFF5C242),
                      bgColor: const Color(0xFFFDF3C0),
                      cardColor: cardColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                      onTap: () => _navigate(const BadgePage()),
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureCard(
                      emoji: '📊',
                      title: 'Gelişim Grafiği',
                      subtitle: 'Kategori bazlı başarı oranların',
                      color: AppColors.softBlue,
                      bgColor: AppColors.paleSoftBlue,
                      cardColor: cardColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                      onTap: () => _navigate(const ChartPage()),
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureCard(
                      emoji: '🃏',
                      title: 'Flashcard Modu',
                      subtitle: 'Kartları çevirerek konuları pekiştir',
                      color: AppColors.sageGreen,
                      bgColor: AppColors.paleSageGreen,
                      cardColor: cardColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                      onTap: () => _navigate(const FlashcardPage()),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<bool>(
                      valueListenable: challengeDoneTodayNotifier,
                      builder: (context, done, _) {
                        return _buildFeatureCard(
                          emoji: done ? '✅' : '🎯',
                          title: 'Günlük Görev',
                          subtitle: done
                              ? 'Bugün tamamlandı · Yarın tekrar görüşürüz!'
                              : '5 soruluk mini test, ekstra XP kazan',
                          color: done
                              ? AppColors.textLight
                              : AppColors.timerOrange,
                          bgColor: done
                              ? (isDark
                                  ? AppColors.darkSurface
                                  : const Color(0xFFEEF0EE))
                              : AppColors.lightPaleYellow,
                          cardColor: cardColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          isDark: isDark,
                          onTap: done
                              ? null
                              : () => _navigate(const DailyChallengePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureCard(
                      emoji: '📝',
                      title: 'Test Geçmişi',
                      subtitle: 'Geçmiş testlerini ve yanlışlarını gör',
                      color: AppColors.textMedium,
                      bgColor: const Color(0xFFEEF0EE),
                      cardColor: cardColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                      onTap: () => _navigate(const HistoryPage()),
                    ),
                    const SizedBox(height: 20),
                    _buildSectionLabel('Ayarlar', textSecondary),
                    const SizedBox(height: 10),
                    _buildSettingsCard(cardColor, textPrimary, textSecondary, isDark),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPageHeader(Color textPrimary) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.sageGreen, AppColors.lightSageGreen],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(child: Text('📖', style: TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 10),
        Text(
          'Profil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        ),
      ],
    );
  }

  Widget _buildProfileCard(Color cardColor, bool isDark) {
    final profile = _profile;
    if (profile == null) return const SizedBox.shrink();

    final level = profile.level;
    final progress = profile.levelProgress;
    final xpToNext = profile.xpToNext;
    final levelIcon = XPLevel.getIcon(profile.totalXp);
    final isMaxLevel = level >= XPLevel.maxLevel;
    final nextLevelXp = XPLevel.nextLevelThreshold(profile.totalXp);
    final currentLevelXp = XPLevel.currentLevelThreshold(profile.totalXp);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.sageGreen, AppColors.softBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.sageGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Seviye ikonu
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(levelIcon, style: const TextStyle(fontSize: 34)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.levelTitle,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isMaxLevel
                                ? '⭐ Seviye $level / ${XPLevel.maxLevel} — MAX'
                                : 'Seviye $level / ${XPLevel.maxLevel}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔥 ${profile.streakDays} günlük seri',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${profile.totalXp}',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const Text('⭐ XP',
                      style: TextStyle(fontSize: 11, color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP ilerleme çubuğu
          Row(
            children: [
              Text(levelIcon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isMaxLevel
                    ? '🏆 MAX Seviye!'
                    : '+$xpToNext XP → Lv.${level + 1}',
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (!isMaxLevel) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentLevelXp XP',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.65)),
                ),
                Text(
                  '$nextLevelXp XP',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.65)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.2),
    );
  }

  Widget _buildStatsRow(Color cardColor, Color textPrimary, Color textSecondary) {
    final total = _stats['totalSessions'] as int? ?? 0;
    final avg = (_stats['averagePercent'] as double? ?? 0).round();
    final best = (_stats['bestPercent'] as double? ?? 0).round();

    return Row(
      children: [
        Expanded(child: _miniStat('📝', '$total', 'Test', cardColor, textPrimary, textSecondary)),
        const SizedBox(width: 10),
        Expanded(child: _miniStat('📈', '%$avg', 'Ortalama', cardColor, textPrimary, textSecondary)),
        const SizedBox(width: 10),
        Expanded(child: _miniStat('🥇', '%$best', 'En İyi', cardColor, textPrimary, textSecondary)),
      ],
    );
  }

  Widget _miniStat(String emoji, String value, String label, Color cardColor, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: textSecondary)),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    final iconBg = isDark ? color.withValues(alpha: 0.15) : bgColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(Color cardColor, Color textPrimary, Color textSecondary, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFE8E0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('🌙', style: TextStyle(fontSize: 20))),
            ),
            title: Text('Karanlık Mod', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
            subtitle: Text(isDark ? 'Açık' : 'Kapalı', style: TextStyle(fontSize: 12, color: textSecondary)),
            trailing: Switch(
              value: isDark,
              onChanged: _toggleDarkMode,
              activeThumbColor: AppColors.sageGreen,
              activeTrackColor: AppColors.sageGreen.withValues(alpha: 0.4),
            ),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkDivider : AppColors.paleSageGreen),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.paleSoftBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('ℹ️', style: TextStyle(fontSize: 20))),
            ),
            title: Text('Uygulama Hakkında', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
            subtitle: Text('Lumina Quiz v1.0', style: TextStyle(fontSize: 12, color: textSecondary)),
            trailing: Icon(Icons.chevron_right_rounded, color: textSecondary),
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  void _navigate(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _loadData());
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [Text('📖 '), Text('Lumina Quiz')]),
        content: const Text(
          'AI destekli ortaokul eğitim quiz uygulaması.\n\n'
          'Claude ile desteklenen sorular, XP sistemi, rozet koleksiyonu ve çok daha fazlası sizi bekliyor! 🌟',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat', style: TextStyle(color: AppColors.sageGreen)),
          ),
        ],
      ),
    );
  }
}
