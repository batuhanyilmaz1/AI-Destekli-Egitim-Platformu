import 'package:flutter/material.dart';
import '../models/difficulty_model.dart';
import '../models/question_model.dart';
import '../theme/app_theme.dart';

class DifficultySheet extends StatelessWidget {
  final QuizCategory category;

  const DifficultySheet({super.key, required this.category});

  static Future<DifficultyLevel?> show(
      BuildContext context, QuizCategory category) {
    return showModalBottomSheet<DifficultyLevel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DifficultySheet(category: category),
    );
  }

  Color _fromHex(String hex) => Color(int.parse('FF$hex', radix: 16));

  @override
  Widget build(BuildContext context) {
    final catBg = _fromHex(category.bgColorHex);
    final catColor = _fromHex(category.colorHex);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Category badge
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: catBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(category.emoji,
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: catColor,
                    ),
                  ),
                  const Text(
                    'Zorluk seviyesi seç',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textMedium),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.paleSageGreen),
          const SizedBox(height: 8),
          // Info row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.paleSageGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('📋', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  '20 soru · Soru sayısı tüm seviyelerde aynı',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Difficulty options
          ...DifficultyLevel.values.map(
            (level) => _DifficultyOption(
              level: level,
              onTap: () => Navigator.pop(context, level),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DifficultyOption extends StatefulWidget {
  final DifficultyLevel level;
  final VoidCallback onTap;

  const _DifficultyOption({required this.level, required this.onTap});

  @override
  State<_DifficultyOption> createState() => _DifficultyOptionState();
}

class _DifficultyOptionState extends State<_DifficultyOption> {
  bool _pressed = false;

  Color _fromHex(String hex) => Color(int.parse('FF$hex', radix: 16));

  @override
  Widget build(BuildContext context) {
    final color = _fromHex(widget.level.colorHex);
    final bgColor = _fromHex(widget.level.bgColorHex);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _pressed ? bgColor : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed ? color : AppColors.shadow,
            width: _pressed ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: _pressed ? 2 : 8,
              offset: Offset(0, _pressed ? 1 : 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Timer circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.level.durationLabel.split(' ')[0],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  Text(
                    'dk',
                    style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.level.emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.level.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.level.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
