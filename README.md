# 📖 Lumina Quiz

<<<<<<< HEAD
<p align="center">
  <img src="lumina.png" width="120" alt="Lumina Quiz App Icon" />
</p>
=======
# 📖 LUMINA QUIZ
### AI Destekli Eğitim Uygulaması
>>>>>>> 53db09685a4fcc5ff729ea87ad2f65662459bad1

<p align="center">
  <b>AI destekli, gamifikasyonlu ortaokul eğitim uygulaması</b><br/>
  Flutter · Gemini AI · SQLite
</p>

---

## Özellikler

### 🧠 AI Quiz Sistemi
- Google Gemini 2.5 Flash ile dinamik soru üretimi
- 8 ders kategorisi: Fizik, Kimya, Biyoloji, Bilgisayar & Programlama, İngilizce, Matematik, Türkçe, Tarih
- 3 zorluk seviyesi: Kolay / Orta / Zor
- Her testte 20 soru, geri sayım sayacı
- Test sonunda AI mentor analizi ve yanlış cevap açıklamaları

### 🎯 Günlük Görev
- 8 dersten herhangi birini seçerek 5 soruluk mini test
- Günde **bir kez** çözülebilir (ana sayfa ve profil arasında senkronize)
- Ekstra XP kazanma fırsatı
- Tam puan için %20 bonus XP

### 📊 Gamifikasyon & Level Sistemi
10 seviyeli XP sistemi:

<<<<<<< HEAD
| Seviye | Unvan | XP Eşiği |
|--------|-------|-----------|
| 1 | 🌱 Aday | 0 |
| 2 | 📖 Öğrenci | 150 |
| 3 | 🔍 Meraklı | 400 |
| 4 | 🧭 Keşifçi | 800 |
| 5 | 🔬 Araştırmacı | 1.400 |
| 6 | 🦉 Bilge | 2.200 |
| 7 | ⚗️ Uzman | 3.300 |
| 8 | 🏆 Usta | 4.800 |
| 9 | 👑 Şampiyon | 6.800 |
| 10 | ⭐ Efsane | 9.500 |
=======
### 🏆 Gamification Sistemi
- **XP Sistemi:** Her doğru cevap XP kazandırır (zorluk çarpanıyla)
- **6 Seviye:** Aday → Öğrenci → Keşifçi → Bilge → Usta → Efsane
- **27 Rozet:** İlk test, tam puan, seri, kategori, tüm kategoriler ve daha fazlası
- **Günlük Seri:** Art arda günler test çözerek seri oluştur
>>>>>>> 53db09685a4fcc5ff729ea87ad2f65662459bad1

### 🏅 Rozet Sistemi (27 Rozet)
- Yeni kazanılan rozetler profil sekmesinde bildirim olarak gösterilir
- Rozetler otomatik açılmaz; kullanıcı tıklayınca altın ışıklı animasyon ile açılır
- Kategori uzmanlık rozetleri, seri rozetleri, başarı rozetleri ve gizli rozetler

### 📝 Test Geçmişi & Yanlış Analizi
- Tüm tamamlanan testler tarih/skor bilgisiyle listelenir
- Herhangi bir teste tıklayarak yanlış yapılan soruları, verilen yanlış cevabı, doğru cevabı ve ipucunu görüntüle
- Tüm sorular doğruysa özel tebrik ekranı

### 📚 Ek Özellikler
- **Flashcard Modu**: Konuları kartlarla pekiştir
- **Çalışma Kitapçığı**: Teste girmeden önce özet oku
- **Gelişim Grafiği**: Kategori bazlı başarı analizi
- **Karanlık Mod**: Göz dostu gece teması
- **Çalışma Serisi (Streak)**: Günlük düzenli çalışma takibi

---

## Teknik Altyapı

| Bileşen | Teknoloji |
|---------|-----------|
| Framework | Flutter 3.x |
| AI | Google Gemini 2.5 Flash REST API |
| Veritabanı | SQLite (sqflite) |
| State | ValueNotifier + setState |
| Veri Saklama | SharedPreferences |
| Animasyon | Flutter Animation Controllers |

---

## Kurulum

<<<<<<< HEAD
=======
```
lib/
├── main.dart                       # Giriş noktası, bottom nav, theme mode
├── theme/
│   └── app_theme.dart              # Renk paleti, light & dark tema
├── models/
│   ├── question_model.dart         # Quiz sorusu & kategoriler
│   ├── quiz_session_model.dart     # Oturum & hata modelleri
│   ├── difficulty_model.dart       # Zorluk seviyeleri
│   └── gamification_model.dart    # XP, rozet, seviye sistemi
├── services/
│   ├── gemini_service.dart         # Gemini API entegrasyonu
│   ├── database_service.dart       # SQLite CRUD işlemleri
│   └── gamification_service.dart  # XP hesaplama, rozet verme
├── data/
│   └── study_content.dart         # Hazır ders notları
└── views/
    ├── splash_screen.dart          # Açılış & cihaz kaydı
    ├── home_page.dart              # Ana sayfa & günlük görev
    ├── profile_page.dart           # Profil & ayarlar
    ├── profile/
    │   ├── badge_page.dart         # Rozet koleksiyonu
    │   └── chart_page.dart         # Gelişim grafiği
    ├── difficulty_sheet.dart       # Zorluk seçimi
    ├── quiz_page.dart              # Quiz ekranı (duraklatma destekli)
    ├── result_page.dart            # Sonuç, XP, AI analizi, paylaşım
    ├── flashcard_page.dart         # Flip kart çalışma modu
    ├── daily_challenge_page.dart   # Günlük 5 soruluk görev
    ├── study_page.dart             # Çalışma kitapçığı
    └── history_page.dart          # Geçmiş testler
```

---

## 🎮 Seviye ve Rozet Sistemi

### ⭐ XP Kazanma

Her doğru cevap XP kazandırır. Zorluk seviyesi çarpan etkisi yapar:

| Zorluk | XP / Doğru | Maks. XP (20 soru) |
|--------|-----------|---------------------|
| Kolay  | 7 XP      | 140 XP              |
| Orta   | 10 XP     | 200 XP              |
| Zor    | 15 XP     | 300 XP              |

### 🎓 Seviye Sıralaması

| Seviye | Unvan      | Gerekli XP |
|--------|------------|------------|
| 1      | Aday       | 0 XP       |
| 2      | Öğrenci    | 100 XP     |
| 3      | Keşifçi    | 300 XP     |
| 4      | Bilge      | 600 XP     |
| 5      | Usta       | 1.000 XP   |
| 6      | Efsane     | 2.000 XP   |

### 🏆 Rozet Koleksiyonu (27 Rozet)

**Başlangıç**

| Rozet | Koşul |
|-------|-------|
| 🌱 İlk Adım | İlk testi tamamla |
| 📖 Araştırmacı | Çalışma kitapçığını aç |
| 🃏 Kart Ustası | Flashcard modunu aç |

**Başarı**

| Rozet | Koşul |
|-------|-------|
| 💯 Tam Puan | Bir testte 20/20 al |
| 🔥 Zorluk Avcısı | Zor seviyede test tamamla |
| 😊 Kolay Başlangıç | Kolay seviyede %100 al |
| ⚡ Hız Şampiyonu | 5 dakikadan kısa sürede testi bitir |

**Günlük Seri**

| Rozet | Koşul |
|-------|-------|
| 🌤️ 3 Gün Serisi | 3 gün art arda test çöz |
| 🔆 7 Gün Serisi | 7 gün art arda test çöz |
| 🌟 14 Gün Serisi | 14 gün art arda test çöz |

**Günlük Görev**

| Rozet | Koşul |
|-------|-------|
| 🎯 Günlük Kahraman | İlk günlük görevi tamamla |
| 🏅 7 Günlük Görev | 7 günlük görevi tamamla |

**Doğru & Test Sayısı**

| Rozet | Koşul |
|-------|-------|
| 💪 100 Doğru | Toplamda 100 doğru cevap |
| 🏆 500 Doğru | Toplamda 500 doğru cevap |
| 👑 1000 Doğru | Toplamda 1000 doğru cevap |
| 📚 10 Test | Toplamda 10 test tamamla |
| 🎓 25 Test | Toplamda 25 test tamamla |

**Kategori Uzmanları**

| Rozet | Koşul |
|-------|-------|
| ⚛️ Fizik Meraklısı | Fizik'te 3 test |
| 🧪 Kimya Öğrencisi | Kimya'da 3 test |
| 🌿 Biyolog | Biyoloji'de 3 test |
| 💻 Kodcu | Bilgisayar'da 3 test |
| 🇬🇧 İngilizce Tutkunu | İngilizce'de 3 test |
| 📐 Matematikçi | Matematik'te 3 test |
| 📝 Türkçe Ustası | Türkçe'de 3 test |
| 🏛️ Tarihçi | Tarih'te 3 test |

**Özel**

| Rozet | Koşul |
|-------|-------|
| 🌍 Çok Yönlü | Tüm kategorilerde en az 1 test |
| 🦉 Gece Kuşu | Gece 22:00'den sonra test tamamla |

---

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android SDK veya iOS Simulator
- Google Gemini API anahtarı

### 1. Repoyu Klonla
```bash
git clone https://github.com/kullaniciadi/lumina-quiz.git
cd lumina-quiz
```

### 2. Bağımlılıkları Yükle
>>>>>>> 53db09685a4fcc5ff729ea87ad2f65662459bad1
```bash
git clone https://github.com/kullanici/fuarProjesi.git
cd fuarProjesi
flutter pub get
flutter run
```

> **Not:** `lib/services/gemini_service.dart` içindeki `_apiKey` değişkenine kendi Gemini API anahtarınızı girmeniz gerekir.

---

## APK

Release APK: `build/app/outputs/flutter-apk/app-release.apk`

```bash
flutter build apk --release
```

---

<p align="center">Ortaokul öğrencileri için AI destekli akıllı öğrenme deneyimi 🌱</p>
