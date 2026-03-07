import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../services/database_service.dart';
import '../../theme/app_theme.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with SingleTickerProviderStateMixin {
  Map<String, double> _averages = {};
  Map<String, int> _counts = {};
  bool _loading = true;
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _load();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = DatabaseService();
    final avgs = await db.getCategoryAverages();
    final counts = await db.getCategoryTestCounts();
    if (mounted) {
      setState(() {
        _averages = avgs;
        _counts = counts;
        _loading = false;
      });
      _animController.forward();
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
        title: Text('Gelişim Grafiği', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.sageGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(cardColor, textPrimary, textSecondary, isDark),
                  const SizedBox(height: 24),
                  Text(
                    'Kategori Bazlı Ortalamalar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  const SizedBox(height: 16),
                  if (_averages.isEmpty)
                    _buildEmptyState(cardColor, textSecondary)
                  else
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) => _buildBars(cardColor, textPrimary, textSecondary, isDark),
                    ),
                  if (_averages.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Test Sayıları',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 16),
                    ..._buildCountList(cardColor, textPrimary, textSecondary, isDark),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(Color cardColor, Color textPrimary, Color textSecondary, bool isDark) {
    final totalTests = _counts.values.fold(0, (a, b) => a + b);
    final overallAvg = _averages.isEmpty
        ? 0.0
        : _averages.values.fold(0.0, (a, b) => a + b) / _averages.length;

    String best = '-';
    double bestVal = 0;
    _averages.forEach((cat, avg) {
      if (avg > bestVal) { bestVal = avg; best = cat; }
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.softBlue, AppColors.sageGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.softBlue.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _summaryItem('📊', '$totalTests', 'Toplam Test')),
          Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
          Expanded(child: _summaryItem('📈', '%${overallAvg.round()}', 'Genel Ortalama')),
          Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
          Expanded(
            child: _summaryItem(
              '🏆',
              best.length > 8 ? '${best.substring(0, 8)}…' : best,
              'En İyi Kategori',
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            overflow: TextOverflow.ellipsis),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildBars(Color cardColor, Color textPrimary, Color textSecondary, bool isDark) {
    final categories = QuizCategory.all;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: categories.asMap().entries.map((entry) {
          final cat = entry.value;
          final avg = _averages[cat.name] ?? 0;
          final pct = avg / 100;
          final barColor = Color(int.parse('FF${cat.colorHex}', radix: 16));
          final barBg = Color(int.parse('FF${cat.bgColorHex}', radix: 16));
          final hasSessions = _counts.containsKey(cat.name);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          cat.name,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                      ],
                    ),
                    Text(
                      hasSessions ? '%${avg.round()}' : '—',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: hasSessions ? barColor : textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : barBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: (pct * _animation.value).clamp(0.0, 1.0),
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: hasSessions ? barColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildCountList(Color cardColor, Color textPrimary, Color textSecondary, bool isDark) {
    return QuizCategory.all.map((cat) {
      final count = _counts[cat.name] ?? 0;
      final barColor = Color(int.parse('FF${cat.colorHex}', radix: 16));
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Text(cat.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(cat.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: barColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count test',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: barColor),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(Color cardColor, Color textSecondary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('📊', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Henüz test verisi yok',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Test çözdükçe grafiğin burada görünecek.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ],
      ),
    );
  }
}
