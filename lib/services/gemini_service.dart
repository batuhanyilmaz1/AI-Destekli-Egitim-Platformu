import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';
import '../models/difficulty_model.dart';

class GeminiService {
  static const String _apiKey = 'your_gemini_api_key';
  static const String _model = 'gemini-2.5-flash';

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  static const String _systemPrompt =
      "Sen 'Lumina Quiz' uygulamasının zeki ve nazik eğitim mentorusun. "
      "Görevin:\n"
      "1. Belirlenen kategoride, belirtilen zorluk seviyesinde, ORTAOKUL öğrencilerine (11-14 yaş) "
      "yönelik müfredata uygun, yaratıcı ve öğretici 20 adet çoktan seçmeli soru üretmek. "
      "Sorular Türkiye Milli Eğitim Bakanlığı 5-8. sınıf müfredatına uygun olmalıdır.\n"
      "2. Soruları şu JSON formatında ver: "
      '{ "question": "...", "options": ["A) ...", "B) ...", "C) ...", "D) ..."], "answer": "A) ...", "hint": "..." }\n'
      "3. Cevap her zaman options listesindeki seçeneklerden biri olmalı.\n"
      "4. Hint (ipucu) alanı kısa, teşvik edici ve öğretici olmalı.\n"
      "5. Test sonunda kullanıcının yanlış yaptığı soruları alıp, bu yanlışların nedenlerini "
      "ortaokul öğrencisinin anlayabileceği en basit ve teşvik edici dille 2-3 cümlede açıklamak.\n"
      "6. Tonlaman her zaman sakinleştirici, sevecen, eğitici ve profesyonel olmalı.";

  Future<List<QuizQuestion>> generateQuestions(
    String category, {
    DifficultyLevel difficulty = DifficultyLevel.medium,
  }) async {
    final userPrompt = '''
Kategori: $category
Zorluk Seviyesi: ${difficulty.geminiLabel}
Hedef Kitle: Ortaokul öğrencileri (Türkiye MEB müfredatı, 5-8. sınıf arası)

Lütfen bu kategoride 20 adet çoktan seçmeli soru üret.
Sorular basit, anlaşılır Türkçe ile yazılmalı.
Yanıtını SADECE aşağıdaki JSON formatında ver, başka hiçbir şey ekleme:

[
  {
    "question": "Soru metni burada",
    "options": ["A) Seçenek bir", "B) Seçenek iki", "C) Seçenek üç", "D) Seçenek dört"],
    "answer": "A) Seçenek bir",
    "hint": "Kısa ve teşvik edici ipucu"
  }
]

20 soru olmalı. Sadece JSON array döndür.
''';

    final responseText = await _callApi(userPrompt);
    return _parseQuestions(responseText);
  }

  Future<String> analyzeMistakes(
    String category,
    List<Mistake> mistakes, {
    int score = 0,
    int total = 20,
  }) async {
    if (mistakes.isEmpty) {
      return '🏆 Tebrikler, tüm soruları doğru yanıtladın!\n\n'
          'Bu muhteşem bir başarı. $category konusunda gerçekten çok iyisin. '
          'Bu başarını korumak için konuyu zaman zaman tekrar etmeyi unutma. '
          'Seni çok gururlu hissediyorum! 💪';
    }

    final percent = ((score / total) * 100).round();
    final mistakeList = mistakes
        .map((m) =>
            '- Soru: ${m.question}\n  Verilen cevap: ${m.userChoice}\n  Doğru cevap: ${m.correctAnswer}')
        .join('\n\n');

    final userPrompt = '''
Bir ortaokul öğrencisi "$category" konusunda quiz tamamladı.
Sonuç: $score / $total doğru (%$percent)

Yanlış yanıtlanan sorular:
$mistakeList

Lütfen öğrenciye yönelik kısa ve samimi bir geri bildirim yaz. Kurallar:
- SADECE düz Türkçe metin yaz. Kesinlikle JSON, kod bloğu veya teknik format kullanma.
- Önce sonuca göre 1-2 cümle genel değerlendirme yap (%60 altıysa daha çok çalışması gerektiğini, üstündeyse iyi gittiğini söyle).
- Sonra her yanlış soru için kısaca neden yanlış olduğunu ve doğru cevabı 1-2 cümleyle açıkla.
- Tonu her zaman sevecen, cesaretlendirici ve sakin tut.
- Emojiler kullanabilirsin ama abartma.
- Yanıtın tamamı düz paragraf ve madde işareti kullanarak yazılsın.
''';

    try {
      return await _callApi(userPrompt);
    } catch (_) {
      return 'Mentor analizi şu an yüklenemiyor. Yine de harika bir çaba sergiledi! 🌟';
    }
  }

  /// Gemini REST API v1 ile doğrudan HTTP isteği gönderir
  Future<String> _callApi(String userPrompt) async {
    final uri = Uri.parse('$_baseUrl?key=$_apiKey');

    final body = jsonEncode({
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': userPrompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 8192,
      },
    });

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = json['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('API boş yanıt döndürdü');
      }
      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      return parts[0]['text'] as String? ?? '';
    } else {
      // Hata detayını parse et
      final errorBody = jsonDecode(response.body);
      final errorMsg =
          errorBody['error']?['message']?.toString() ?? response.body;
      throw Exception(_parseApiError(response.statusCode, errorMsg));
    }
  }

  String _parseApiError(int statusCode, String message) {
    if (statusCode == 429) {
      final retryMatch =
          RegExp(r'retry after (\d+)', caseSensitive: false).firstMatch(message);
      if (retryMatch != null) {
        return 'API kotası aşıldı. ~${retryMatch.group(1)} saniye sonra tekrar dene.';
      }
      return 'API kotası aşıldı. Lütfen 1 dakika bekleyip tekrar dene.';
    }
    if (statusCode == 400) {
      return 'Geçersiz istek. API anahtarını kontrol et.';
    }
    if (statusCode == 403) {
      return 'Erişim reddedildi. API anahtarının Gemini API için etkinleştirildiğinden emin ol.';
    }
    if (statusCode == 404) {
      return 'Model bulunamadı. İnternet bağlantını kontrol et.';
    }
    return 'Sunucu hatası ($statusCode). Lütfen tekrar dene.';
  }

  List<QuizQuestion> _parseQuestions(String raw) {
    String cleaned = raw.trim();

    // Markdown kod bloğunu temizle
    if (cleaned.startsWith('```')) {
      final firstNewline = cleaned.indexOf('\n');
      if (firstNewline != -1) {
        cleaned = cleaned.substring(firstNewline + 1);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.lastIndexOf('```'));
      }
    }

    final startIdx = cleaned.indexOf('[');
    final endIdx = cleaned.lastIndexOf(']');
    if (startIdx == -1 || endIdx == -1) {
      throw Exception('Geçersiz JSON formatı alındı. Tekrar dene.');
    }
    cleaned = cleaned.substring(startIdx, endIdx + 1).trim();

    final List<dynamic> jsonList = jsonDecode(cleaned);
    return jsonList
        .map((item) => QuizQuestion.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
