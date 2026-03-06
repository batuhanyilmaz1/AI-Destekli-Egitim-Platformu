import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/quiz_session_model.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<QuizSession> _sessions = [];
  Map<String, dynamic> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final db = DatabaseService();
      final sessions = await db.getAllSessions();
      final stats = await db.getStats();
      if (mounted) {
        setState(() {
          _sessions = sessions;
          _stats = stats;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteSession(int id) async {
    await DatabaseService().deleteSession(id);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Geçmiş Testler'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.sageGreen),
            )
          : _sessions.isEmpty
              ? _buildEmptyState()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildStatsHeader()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${_sessions.length} test kaydı',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildSessionCard(_sessions[index]),
                          childCount: _sessions.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.paleSageGreen,
              shape: BoxShape.circle,
            ),
            child: const Text('📋', style: TextStyle(fontSize: 44)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Henüz test yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'İlk testini tamamladığında\nsonuçların burada görünecek.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final totalSessions = _stats['totalSessions'] as int? ?? 0;
    final avgPercent = (_stats['averagePercent'] as double? ?? 0).round();
    final bestPercent = (_stats['bestPercent'] as double? ?? 0).round();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.sageGreen, AppColors.softBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.sageGreen.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                  label: 'Toplam Test', value: '$totalSessions'),
            ),
            _VerticalDivider(),
            Expanded(
              child: _StatItem(
                  label: 'Ortalama', value: '%$avgPercent'),
            ),
            _VerticalDivider(),
            Expanded(
              child: _StatItem(
                  label: 'En İyi', value: '%$bestPercent'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(QuizSession session) {
    final percentage = (session.percentage * 100).round();
    final color = percentage >= 70
        ? AppColors.correctGreen
        : percentage >= 50
            ? AppColors.timerOrange
            : AppColors.wrongRed;
    final bgColor = percentage >= 70
        ? AppColors.correctGreenLight
        : percentage >= 50
            ? const Color(0xFFFAEBD6)
            : AppColors.wrongRedLight;

    final dateStr = DateFormat('dd.MM.yyyy  HH:mm').format(session.date);
    final durationStr =
        '${session.durationSeconds ~/ 60}dk ${session.durationSeconds % 60}sn';

    return Dismissible(
      key: Key(session.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.wrongRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded,
            color: AppColors.wrongRed),
      ),
      onDismissed: (_) {
        if (session.id != null) _deleteSession(session.id!);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '%$percentage',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.category,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${session.score}/${session.totalQuestions} doğru · $durationStr',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: 6,
                height: 40,
                child: LinearProgressIndicator(
                  value: session.percentage,
                  backgroundColor: bgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}
