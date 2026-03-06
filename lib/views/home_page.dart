import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/difficulty_model.dart';
import '../services/gemini_service.dart';
import '../theme/app_theme.dart';
import 'quiz_page.dart';
import 'history_page.dart';
import 'difficulty_sheet.dart';
import 'study_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  bool _isLoading = false;
  String? _loadingCategory;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  Future<void> _onCategoryTap(QuizCategory category) async {
    final difficulty = await DifficultySheet.show(context, category);
    if (difficulty == null) return; // kullanıcı iptal etti
    await _startQuiz(category, difficulty);
  }

  Future<void> _startQuiz(
      QuizCategory category, DifficultyLevel difficulty) async {
    setState(() {
      _isLoading = true;
      _loadingCategory = category.name;
    });

    try {
      final service = GeminiService();
      final questions = await service.generateQuestions(
        category.name,
        difficulty: difficulty,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => QuizPage(
            category: category,
            questions: questions,
            difficulty: difficulty,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    // Kullanıcıya göstermek için temiz mesaj al (Exception: prefix'ini kaldır)
    final cleanMsg = message.replaceFirst('Exception: ', '');
    final isQuota = cleanMsg.contains('kota') || cleanMsg.contains('quota') ||
        cleanMsg.contains('rate') || cleanMsg.contains('429');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(isQuota ? '⏳' : '⚠️',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(isQuota ? 'Kota Aşıldı' : 'Bir sorun oluştu'),
          ],
        ),
        content: Text(
          cleanMsg,
          style: const TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam',
                style: TextStyle(color: AppColors.sageGreen)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                  SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildStatsRow(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildStudyBookBanner(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 4)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionTitle('Kategoriler'),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _CategoryCard(
                          category: QuizCategory.all[index],
                          index: index,
                          onTap: () =>
                              _onCategoryTap(QuizCategory.all[index]),
                        );
                      },
                      childCount: QuizCategory.all.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.paleSageGreen.withValues(alpha: 0.4),
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.paleSoftBlue.withValues(alpha: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerOpacity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.sageGreen,
                              AppColors.lightSageGreen
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('✦',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Lumina Quiz',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bugün ne öğreniyoruz? 🌱',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HistoryPage()),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.history_rounded,
                      color: AppColors.textDark, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 8),
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
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '20 Soru · 10 Dakika',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'AI mentor analizli\nkişisel quiz deneyimi',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text('🤖', style: TextStyle(fontSize: 28)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyBookBanner() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StudyPage()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.softBlue.withValues(alpha: 0.3), width: 1.5),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.paleSoftBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('📖', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Çalışma Kitapçığı',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Teste girmeden önce konuları çalış 📚',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMedium),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.paleSoftBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text(
                    'Aç',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.softBlue,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 10, color: AppColors.softBlue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
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
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.sageGreen,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$_loadingCategory soruları hazırlanıyor...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '🤖 AI mentor soruları oluşturuyor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final QuizCategory category;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slide = Tween<Offset>(
            begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _fromHex(String hex) {
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final color = _fromHex(widget.category.colorHex);
    final bgColor = _fromHex(widget.category.bgColorHex);

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: _pressed ? 4 : 12,
                  offset: Offset(0, _pressed ? 2 : 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.category.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.category.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Başla',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 10, color: color),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
