import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../data/study_content.dart';
import '../models/difficulty_model.dart';
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';

/// HTTP / yük deneme sınıflandırması (yeniden deneme için).
class AiApiException implements Exception {
  AiApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  bool get isRetryable =>
      statusCode == 429 ||
      statusCode == 502 ||
      statusCode == 503 ||
      statusCode == 504 ||
      statusCode == 529;

  @override
  String toString() => message;
}

class _ClaudeResult {
  _ClaudeResult({required this.text, this.stopReason});

  final String text;
  final String? stopReason;
}

/// Anthropic Claude Messages API ile soru üretimi ve mentor analizi.
class ClaudeService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _anthropicVersion = '2023-06-01';
  /// Varsayılan: Anthropic Haiku 4.5 — hızlı, düşük maliyet.
  /// Liste ve tam ID snapshot: https://docs.anthropic.com/en/docs/about-claude/models
  static const String _defaultQuizModel = 'claude-haiku-4-5-20251001';
  static const String _defaultMentorModel = 'claude-haiku-4-5-20251001';

  static const String _systemPrompt =
      "Sen 'Lumina Quiz' uygulamasının zeki ve nazik eğitim mentorusun. "
      "Görevin:\n"
      "1. Belirlenen kategoride, belirtilen zorluk seviyesinde, ORTAOKUL öğrencilerine (11-14 yaş) "
      "yönelik müfredata uygun, yaratıcı ve öğretici çoktan seçmeli sorular üretmek. "
      "Sorular Türkiye Milli Eğitim Bakanlığı 5-8. sınıf müfredatına uygun olmalıdır.\n"
      "2. ÇOK ÖNEMLİ - ÇEŞİTLİLİK KURALLARI:\n"
      "   - Her soru üretiminde FARKLI konular ve alt başlıklar seç. "
      "Aynı konuyu birden fazla soruda TEKRARLAMA.\n"
      "   - Soruların yaklaşık yarısını uygulama/hesaplama, yarısını kavram/bilgi türünde yap.\n"
      "   - Kategori içindeki TÜM ALT KONULARI dengeli şekilde dağıt.\n"
      "   - Soru köklerini birbirinden tamamen farklı yapıda kur.\n"
      "   - Seçeneklerin sıralamasını ve doğru cevabın konumunu (A/B/C/D) rastgele değiştir.\n"
      "3. Soruları şu JSON formatında ver: "
      '{ "question": "...", "options": ["A) ...", "B) ...", "C) ...", "D) ..."], "answer": "A) ...", "hint": "..." }\n'
      "4. Cevap her zaman options listesindeki seçeneklerden biri olmalı.\n"
      "5. Hint (ipucu) alanı kısa, teşvik edici ve öğretici olmalı.\n"
      "6. Yanlış cevaplara iki üç cümlede açıklayıcı mentorluk yap.\n"
      "7. Tonun sakinleştirici, sevecen, eğitici ve profesyonel olmalı.\n"
      "8. Soru ve ipucunda JSON için çift tırnak (\") metin içinde kullanma; tek tırnak veya tire kullan.\n";

  static const int _maxApiAttempts = 5;
  /// Tek istekte daha fazla soru = daha az HTTP turu (toplam süreyi kısaltır).
  static const int _chunkSize = 14;

  static int _maxOutputTokensForQuizBatch(int batchSize) {
    final n = batchSize.clamp(1, 25);
    return (700 + n * 500).clamp(2048, 8192);
  }

  static String _apiKey() {
    const fromDefine = String.fromEnvironment('CLAUDE_API_KEY', defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine.trim();
    final fromEnv = dotenv.env['CLAUDE_API_KEY']?.trim() ?? '';
    return fromEnv;
  }

  /// Önce `--dart-define=CLAUDE_MODEL_QUIZ=...`, sonra [.env].
  static String _resolvedQuizModel() {
    const d = String.fromEnvironment('CLAUDE_MODEL_QUIZ', defaultValue: '');
    if (d.isNotEmpty) return d.trim();
    final e = dotenv.env['CLAUDE_MODEL_QUIZ']?.trim();
    if (e != null && e.isNotEmpty) return e;
    return _defaultQuizModel;
  }

  /// Mentor analizi; ayrı model istersen `CLAUDE_MODEL_MENTOR`.
  static String _resolvedMentorModel() {
    const d = String.fromEnvironment('CLAUDE_MODEL_MENTOR', defaultValue: '');
    if (d.isNotEmpty) return d.trim();
    final e = dotenv.env['CLAUDE_MODEL_MENTOR']?.trim();
    if (e != null && e.isNotEmpty) return e;
    return _defaultMentorModel;
  }

  Future<List<QuizQuestion>> generateQuestions(
    String categoryName, {
    required String categoryId,
    DifficultyLevel difficulty = DifficultyLevel.medium,
    int count = 20,
  }) async {
    final key = _apiKey();
    if (key.isEmpty) {
      throw Exception(
        'Claude API anahtarı tanımlı değil. Proje kökünde .env dosyasına CLAUDE_API_KEY ekleyin '
        'veya derlemede --dart-define=CLAUDE_API_KEY=... kullanın.',
      );
    }

    final seedBase = DateTime.now().millisecondsSinceEpoch % 100000;
    final syllabus = StudyContent.quizSyllabusLine(categoryId);

    final all = <QuizQuestion>[];
    var chunkIndex = 0;

    while (all.length < count) {
      final remaining = count - all.length;
      var batchGoal = remaining > _chunkSize ? _chunkSize : remaining;
      List<QuizQuestion>? batch;
      Object? lastFailure;

      for (var sizeTry = 0; sizeTry < 4 && batch == null; sizeTry++) {
        if (batchGoal < 1) batchGoal = 1;

        try {
          final prompt = _buildQuestionPrompt(
            categoryName,
            syllabus: syllabus,
            difficulty: difficulty,
            batchSize: batchGoal,
            seed: seedBase + chunkIndex,
          );

          final result =
              await _callApiWithRetries(
                key,
                prompt,
                model: _resolvedQuizModel(),
                maxOutputTokens: _maxOutputTokensForQuizBatch(batchGoal),
              );

          if (result.stopReason == 'max_tokens') {
            lastFailure ??= Exception(
              'Model yanıtı token sınırında kesildi. Daha az soruyla tekrar deneniyor.',
            );
            batchGoal = (batchGoal <= 2) ? 1 : batchGoal - 2;
            continue;
          }

          batch = _parseQuestions(result.text);
        } catch (e) {
          lastFailure = e;

          /// 401 vb. kritik durumları gizlemeyelim.
          final api = _asAiApi(e);
          if (api != null && !api.isRetryable) rethrow;

          if (!_isTransientQuizFailure(e)) rethrow;

          await Future<void>.delayed(
            Duration(milliseconds: 600 * (sizeTry + 1)),
          );
        }
      }

      if (batch == null) {
        throw Exception(_friendlyQuizFailure(lastFailure));
      }

      all.addAll(batch);
      chunkIndex++;
    }

    return all.take(count).toList();
  }

  String _buildQuestionPrompt(
    String category, {
    required String syllabus,
    required DifficultyLevel difficulty,
    required int batchSize,
    required int seed,
  }) {
    final syllabusBlock = syllabus.isEmpty ? '' : '$syllabus\n\n';

    return '''
$syllabusBlock
Kategori: $category
Zorluk Seviyesi: ${difficulty.aiDifficultyLabel}
Hedef Kitle: Ortaokul öğrencileri (Türkiye MEB müfredatı, 5-8. sınıf arası)
Oturum/Parti Kodu: $seed (bu partide farklı sorular üret)

ÖNEMLİ: Tam $batchSize adet ÖZGÜN soru üret. Sorular kısa ve net olsun.
Daha önce sorulmuş olabilecek sorulardan KAÇIN.

KRİTİK — ÇIKTI FORMATI:
- Yanıtın İLK karakteri [ olmalı, SON karakteri ] olmalı.
- Öncesinde veya sonrasında açıklama, başlık, "İşte sorular:" vb. yazma.
- Markdown kod kutusu kullanma; ham JSON üret.

Yanıt YALNIZCA şu yapı olmalı: bir JSON dizisi.

Geçerli JSON kuralları:
- Alan adları: question, options (4 eleman), answer, hint
- String içinde " karakterini kullanma

Format:
[
  {
    "question": "Soru metni burada",
    "options": ["A) Seçenek bir", "B) Seçenek iki", "C) Seçenek üç", "D) Seçenek dört"],
    "answer": "A) Seçenek bir",
    "hint": "Kısa ipucu"
  }
]

$batchSize soru. Sadece JSON array döndür.
''';
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
- Kalın veya italik için * veya ** gibi Markdown işaretleri KULLANMA; vurgulamak için tırnak veya doğal cümle kur.
- Önce sonuca göre 1-2 cümle genel değerlendirme yap (%60 altıysa daha çok çalışması gerektiğini, üstündeyse iyi gittiğini söyle).
- Sonra her yanlış soru için kısaca neden yanlış olduğunu ve doğru cevabı 1-2 cümleyle açıkla.
- Tonu her zaman sevecen, cesaretlendirici ve sakin tut.
- Emojiler kullanabilirsin ama abartma.
- Yanıtın tamamı düz paragraf ve madde işareti kullanarak yazılsın.
''';

    final key = _apiKey();
    if (key.isEmpty) {
      return 'Mentor analizi şu an yüklenemiyor. Yine de harika bir çaba sergiledi! 🌟';
    }

    try {
      final r = await _callApiWithRetries(
        key,
        userPrompt,
        model: _resolvedMentorModel(),
        maxOutputTokens: 2048,
      );
      return r.text;
    } catch (_) {
      return 'Mentor analizi şu an yüklenemiyor. Yine de harika bir çaba sergiledi! 🌟';
    }
  }

  AiApiException? _asAiApi(Object e) {
    return e is AiApiException ? e : null;
  }

  bool _isTransientQuizFailure(Object e) {
    if (e is AiApiException) return e.isRetryable;
    if (e is TimeoutException || e is SocketException) return true;
    if (e is http.ClientException) return true;
    return e is FormatException;
  }

  /// Kullanıcıya gösterilecek Türkçe özet — önce gerçek hata nedeni (ağ kotası tek değildi).
  String _friendlyQuizFailure(Object? failure) {
    if (failure == null) {
      return 'Sorular alınamadı. Tekrar dene.';
    }
    final api = _asAiApi(failure);
    if (api != null) return api.message;

    if (failure is FormatException) {
      return 'Sorular ayrıştırılamadı (model çıktısı beklenen JSON değil). '
          'Uygulamayı güncellediğinden emin ol veya tekrar dene.';
    }

    final s = failure.toString().replaceFirst('Exception: ', '').trim();
    if (s.isEmpty) return 'Sorular alınamadı. Tekrar dene.';
    return 'Sorular alınamadı: $s';
  }

  Future<_ClaudeResult> _callApiWithRetries(
    String apiKey,
    String userPrompt, {
    required String model,
    int? maxOutputTokens,
  }) async {
    Object? lastError;
    for (var attempt = 0; attempt < _maxApiAttempts; attempt++) {
      try {
        return await _callApiOnce(
          apiKey,
          userPrompt,
          model: model,
          maxOutputTokens: maxOutputTokens,
        );
      } catch (e) {
        lastError = e;
        final retry = _shouldRetry(e, attempt);
        if (!retry) rethrow;
        await Future<void>.delayed(
          Duration(milliseconds: 700 * (1 << attempt)),
        );
      }
    }
    if (lastError != null) {
      throw lastError;
    }
    throw Exception('Bilinmeyen API hatası');
  }

  bool _shouldRetry(Object e, int attempt) {
    if (attempt >= _maxApiAttempts - 1) return false;
    if (e is TimeoutException || e is SocketException) return true;
    if (e is http.ClientException) return true;
    if (e is AiApiException) return e.isRetryable;
    return false;
  }

  Future<_ClaudeResult> _callApiOnce(
    String apiKey,
    String userPrompt, {
    required String model,
    int? maxOutputTokens,
  }) async {
    final uri = Uri.parse(_baseUrl);

    final body = jsonEncode({
      'model': model,
      'max_tokens': maxOutputTokens ?? 8192,
      'temperature': 0.55,
      'system': _systemPrompt,
      'messages': [
        {
          'role': 'user',
          'content': userPrompt,
        },
      ],
    });

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': _anthropicVersion,
          },
          body: body,
        )
        .timeout(const Duration(seconds: 90));

    if (response.statusCode != 200) {
      String errorMsg;
      try {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        final err = map['error'];
        if (err is Map<String, dynamic>) {
          errorMsg = err['message']?.toString() ?? response.body;
        } else {
          errorMsg = response.body;
        }
      } catch (_) {
        errorMsg = response.body;
      }
      throw AiApiException(
        response.statusCode,
        _parseApiError(response.statusCode, errorMsg),
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final text = _concatenateAssistantText(json);
    if (text.isEmpty) {
      throw Exception('API boş metin döndürdü');
    }

    final stopReason = json['stop_reason']?.toString();
    return _ClaudeResult(text: text, stopReason: stopReason);
  }

  String _concatenateAssistantText(Map<String, dynamic> json) {
    final content = json['content'];
    if (content is! List<dynamic>) return '';
    final b = StringBuffer();
    for (final block in content) {
      if (block is! Map<String, dynamic>) continue;
      if (block['type'] == 'text') {
        final t = block['text'];
        if (t is String) b.write(t);
      }
    }
    return b.toString();
  }

  String _parseApiError(int statusCode, String message) {
    if (statusCode == 404) {
      return 'Model bulunamadı (404). .env içinde CLAUDE_MODEL_QUIZ ve CLAUDE_MODEL_MENTOR '
          'değerlerini Anthropic dokümantasyonundaki güncel model ID ile eşleştir; '
          'örnek: claude-haiku-4-5 veya tam snapshot adı.';
    }
    if (statusCode == 401) {
      return 'Anthropic API anahtarı geçersiz veya eksik.';
    }
    if (statusCode == 429) {
      final retryMatch =
          RegExp(r'retry after (\d+)', caseSensitive: false).firstMatch(message);
      if (retryMatch != null) {
        return 'API kotası aşıldı. ~${retryMatch.group(1)} saniye sonra tekrar dene.';
      }
      return 'Çok sık istek. Lütfen kısa bir süre sonra tekrar dene.';
    }
    if (statusCode == 529) {
      return 'Anthropic sunucuları geçici yoğun (aşırı yüklenme). Birkaç saniye sonra tekrar dene.';
    }
    if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
      return 'Anthropic tarafında geçici sorun (HTTP $statusCode). Tekrar dene.';
    }
    if (statusCode >= 400) {
      final short = message.length > 280 ? '${message.substring(0, 280)}...' : message;
      return 'İstek hatası ($statusCode): $short';
    }
    return 'Sunucu hatası ($statusCode). Lütfen tekrar dene.';
  }

  List<QuizQuestion> _parseQuestions(String raw) {
    String cleaned = raw.trim();

    if (cleaned.startsWith('```')) {
      final firstNewline = cleaned.indexOf('\n');
      if (firstNewline != -1) {
        cleaned = cleaned.substring(firstNewline + 1);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.lastIndexOf('```'));
      }
    }

    cleaned = cleaned.trimLeft();

    /// Yanıt tek nesne ise: `{ "question": ..., "options": ... }`
    if (cleaned.startsWith('{')) {
      final end = _endIndexOfMatchingBracket(cleaned, 0, '{', '}');
      if (end != null) {
        try {
          final one =
              jsonDecode(cleaned.substring(0, end + 1)) as Map<String, dynamic>;
          final q = _decodeQuestionList(<dynamic>[one]);
          if (q.isNotEmpty) return q;
        } catch (_) {}
      }
    }

    /// Ön yüz metni (`İşte sorular:`) sonra gelen diziyi yakalamaya çalış.
    var startIdx = cleaned.indexOf('[');
    if (startIdx == -1) {
      throw const FormatException('JSON dizi başlangıcı bulunamadı');
    }

    final jsonArrayStart = cleaned.indexOf('[{"');
    if (jsonArrayStart != -1 && jsonArrayStart > startIdx) {
      startIdx = jsonArrayStart;
    }

    cleaned = cleaned.substring(startIdx);
    final endIdx = _endIndexOfMatchingBracket(cleaned, 0, '[', ']');
    final String arraySlice;
    if (endIdx != null) {
      arraySlice = cleaned.substring(0, endIdx + 1);
    } else {
      arraySlice = cleaned;
    }

    List<dynamic> jsonList;
    try {
      jsonList = jsonDecode(arraySlice) as List<dynamic>;
    } on FormatException {
      jsonList = List<dynamic>.from(_salvageQuestionObjects(arraySlice));
      if (jsonList.isEmpty) {
        throw const FormatException('Geçerli soru nesnesi çıkarılamadı');
      }
    }

    final questions = _decodeQuestionList(jsonList);
    if (questions.isEmpty) {
      throw const FormatException('Geçerli soru üretilemedi');
    }
    return questions;
  }

  List<QuizQuestion> _decodeQuestionList(List<dynamic> jsonList) {
    final questions = <QuizQuestion>[];
    for (final item in jsonList) {
      if (item is! Map<String, dynamic>) continue;
      try {
        final q = QuizQuestion.fromJson(item);
        if (_isValid(q)) questions.add(q);
      } catch (_) {}
    }
    return questions;
  }

  int? _endIndexOfMatchingBracket(
    String s,
    int open,
    String openCh,
    String closeCh,
  ) {
    var depth = 0;
    var inStr = false;
    var escape = false;
    for (var i = open; i < s.length; i++) {
      final c = s[i];
      if (escape) {
        escape = false;
        continue;
      }
      if (inStr) {
        if (c == r'\') {
          escape = true;
        } else if (c == '"') {
          inStr = false;
        }
        continue;
      }
      if (c == '"') {
        inStr = true;
        continue;
      }
      if (c == openCh) {
        depth++;
      } else if (c == closeCh) {
        depth--;
        if (depth == 0) return i;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _salvageQuestionObjects(String fromArraySlice) {
    final out = <Map<String, dynamic>>[];
    final start = fromArraySlice.indexOf('[');
    if (start == -1) return out;

    var i = start + 1;
    while (i < fromArraySlice.length) {
      while (
          i < fromArraySlice.length && ' \t\n\r,'.contains(fromArraySlice[i])) {
        i++;
      }
      if (i >= fromArraySlice.length || fromArraySlice[i] == ']') break;

      if (fromArraySlice[i] != '{') {
        i++;
        continue;
      }

      final close = _endIndexOfMatchingBracket(fromArraySlice, i, '{', '}');
      if (close == null) break;

      final slice = fromArraySlice.substring(i, close + 1);
      try {
        out.add(jsonDecode(slice) as Map<String, dynamic>);
      } catch (_) {}

      i = close + 1;
    }
    return out;
  }

  bool _isValid(QuizQuestion q) {
    if (q.question.trim().isEmpty) return false;
    if (q.options.length != 4) return false;
    if (!q.options.contains(q.answer)) return false;
    if (q.options.any((o) => o.trim().isEmpty)) return false;
    return true;
  }
}
