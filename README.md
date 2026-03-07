# 📖 Lumina Quiz

<p align="center">
  <img src="lumina.png" width="120" alt="Lumina Quiz App Icon" />
</p>

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
