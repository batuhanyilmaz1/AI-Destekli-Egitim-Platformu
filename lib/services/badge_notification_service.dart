import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

/// Kazanılan ama henüz kullanıcı tarafından açılmamış rozetleri yönetir.
class BadgeNotificationService {
  static const _key = 'unseen_badge_ids';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    newBadgeCountNotifier.value = list.length;
  }

  static Future<void> addUnseenBadges(List<String> badgeIds) async {
    if (badgeIds.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final current = Set<String>.from(prefs.getStringList(_key) ?? []);
    current.addAll(badgeIds);
    await prefs.setStringList(_key, current.toList());
    newBadgeCountNotifier.value = current.length;
  }

  static Future<Set<String>> getUnseenBadgeIds() async {
    final prefs = await SharedPreferences.getInstance();
    return Set<String>.from(prefs.getStringList(_key) ?? []);
  }

  static Future<void> markAsSeen(String badgeId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    current.remove(badgeId);
    await prefs.setStringList(_key, current);
    newBadgeCountNotifier.value = current.length;
  }
}
