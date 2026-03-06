class StudyTopic {
  final String title;
  final String emoji;
  final List<StudySection> sections;

  const StudyTopic({
    required this.title,
    required this.emoji,
    required this.sections,
  });
}

class StudySection {
  final String heading;
  final String body;
  final List<String> keyPoints;

  const StudySection({
    required this.heading,
    required this.body,
    required this.keyPoints,
  });
}

class StudyContent {
  static const Map<String, List<StudyTopic>> content = {
    'physics': _physics,
    'chemistry': _chemistry,
    'biology': _biology,
    'cs': _cs,
    'english': _english,
  };

  // ─────────────────── FİZİK ───────────────────
  static const List<StudyTopic> _physics = [
    StudyTopic(
      title: 'Kuvvet ve Hareket',
      emoji: '🏃',
      sections: [
        StudySection(
          heading: 'Kuvvet Nedir?',
          body:
              'Kuvvet, bir cismin şeklini veya hareketini değiştirmeye çalışan etkidir. '
              'Kuvveti ölçmek için "Newton (N)" birimi kullanılır. '
              'Kuvvetin büyüklüğü ve yönü vardır; yani kuvvet bir vektör büyüklüktür.',
          keyPoints: [
            'Kuvvet birimi: Newton (N)',
            'İtme ve çekme birer kuvvettir',
            'Kuvvet hem büyüklük hem yöne sahiptir',
            'Birden fazla kuvvet aynı anda etki edebilir',
          ],
        ),
        StudySection(
          heading: "Newton'un Hareket Yasaları",
          body:
              '1. Yasa (Eylemsizlik): Üzerine net kuvvet etki etmeyen bir cisim, hareketsizse hareketsiz kalır; hareket halindeyse sabit hızla düz hareket eder.\n\n'
              '2. Yasa (F = m × a): Bir cisme uygulanan net kuvvet, cismin kütlesi ile ivmesinin çarpımına eşittir.\n\n'
              '3. Yasa (Etki-Tepki): Her etki kuvvetine eşit büyüklükte ve zıt yönde bir tepki kuvveti vardır.',
          keyPoints: [
            '1. Yasa → Eylemsizlik ilkesi',
            '2. Yasa → F = m × a formülü',
            '3. Yasa → Etki = Tepki (büyüklük aynı, yön zıt)',
            'Kütle büyükse hızlanma azdır, kütle küçükse hızlanma büyüktür',
          ],
        ),
        StudySection(
          heading: 'Sürtünme Kuvveti',
          body:
              'Sürtünme, iki yüzeyin birbirine temas ettiğinde harekete karşı ortaya çıkan dirençtir. '
              'Statik sürtünme (harekete başlamayı engeller) ve kinetik sürtünme (hareketi yavaşlatır) olmak üzere ikiye ayrılır.',
          keyPoints: [
            'Sürtünme her zaman harekete zıt yönde etki eder',
            'Kaba yüzeyler daha fazla sürtünme oluşturur',
            'Yağlama, sürtünmeyi azaltır',
            'Sürtünme olmadan yürüyemezdik',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Enerji ve İş',
      emoji: '⚡',
      sections: [
        StudySection(
          heading: 'Enerji Türleri',
          body:
              'Kinetik Enerji: Hareket eden cisimlerin sahip olduğu enerjidir. '
              'Hız arttıkça kinetik enerji de artar.\n\n'
              'Potansiyel Enerji: Cisimlerin konumundan veya şeklinden kaynaklanan enerjidir. '
              'Yüksekte olan bir cisim, çekim potansiyel enerjisine sahiptir.',
          keyPoints: [
            'Kinetik enerji: hareket enerjisi',
            'Potansiyel enerji: konum enerjisi',
            'Enerji yok olmaz, bir türden başkasına dönüşür',
            'Enerji birimi: Joule (J)',
          ],
        ),
        StudySection(
          heading: 'İş Nedir?',
          body:
              'Fiziksel anlamda iş, bir kuvvetin cismi kuvvet yönünde hareket ettirmesiyle yapılır. '
              'İş = Kuvvet × Yol formülüyle hesaplanır. '
              'Kuvvet uygulanmasına rağmen cisim hareket etmiyorsa fiziksel iş yapılmış sayılmaz.',
          keyPoints: [
            'İş = Kuvvet × Yol (W = F × d)',
            'İş birimi: Joule (J)',
            'Cisim hareket etmezse iş sıfırdır',
            'Kuvvet ve yer değiştirme aynı yöndeyse iş pozitiftir',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Işık ve Ses',
      emoji: '🔊',
      sections: [
        StudySection(
          heading: 'Işığın Özellikleri',
          body:
              'Işık, düz bir çizgide yayılan elektromanyetik bir dalgadır. '
              'Boşlukta saniyede yaklaşık 300.000 km hızla hareket eder. '
              'Işık yansıma ve kırılma gibi olaylar yaşar.',
          keyPoints: [
            'Işık düz yayılır',
            'Işık hızı ≈ 300.000 km/s (boşlukta)',
            'Yansıma: ışığın yüzeyden geri dönmesi',
            'Kırılma: ışığın farklı ortama geçişte yön değiştirmesi',
            'Güneş ışığı beyaz ışıktır; prizmadan geçince gökkuşağı renklerine ayrılır',
          ],
        ),
        StudySection(
          heading: 'Sesin Özellikleri',
          body:
              'Ses, titreşen cisimlerin oluşturduğu mekanik bir dalgadır. '
              'Yayılması için maddesel ortam gerekir; boşlukta ses yayılamaz. '
              'Ses katı, sıvı ve gazlarda yayılabilir. Katılarda en hızlı yayılır.',
          keyPoints: [
            'Ses mekanik dalgadır',
            'Boşlukta ses yayılamaz',
            'Ses katıda > sıvıda > havada hızlıdır',
            'Frekans arttıkça ses tizi, azalınca pesi olur',
            'Desibel (dB): ses şiddeti birimi',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Elektrik',
      emoji: '💡',
      sections: [
        StudySection(
          heading: 'Elektrik Yükü ve Akım',
          body:
              'Madde proton (+) ve elektron (−) içerir. '
              'Elektrik akımı, elektron akışıdır. '
              'Devre kapalı olduğunda elektronlar hareket eder ve akım oluşur.',
          keyPoints: [
            'Proton: pozitif yük, elektron: negatif yük',
            'Elektrik akımı birimi: Amper (A)',
            'Gerilim (voltaj) birimi: Volt (V)',
            'Direnç birimi: Ohm (Ω)',
            "Ohm Yasası: V = I × R",
          ],
        ),
        StudySection(
          heading: 'Seri ve Paralel Devre',
          body:
              'Seri devrede elemanlar arka arkaya bağlıdır. Akım her yerden aynı geçer, '
              'gerilim ise elemanlar arasında paylaşılır.\n\n'
              'Paralel devrede elemanlar yan yana bağlıdır. Gerilim her elemanda aynıdır, '
              'akım ise dallara paylaşılır. Evlerdeki prizler paralel bağlıdır.',
          keyPoints: [
            'Seri: akım sabit, gerilim bölünür',
            'Paralel: gerilim sabit, akım bölünür',
            'Bir seri devre elemanı bozulursa devre durur',
            'Paralel devrede bir eleman bozulursa diğerleri çalışmaya devam eder',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── KİMYA ───────────────────
  static const List<StudyTopic> _chemistry = [
    StudyTopic(
      title: 'Madde ve Özellikleri',
      emoji: '🧊',
      sections: [
        StudySection(
          heading: 'Madde Nedir?',
          body:
              'Kütlesi ve hacmi olan her şeye madde denir. Maddeler; saf maddeler ve '
              'karışımlar olarak ikiye ayrılır. Saf maddeler sabit bir bileşime sahiptir.',
          keyPoints: [
            'Saf maddeler: elementler ve bileşikler',
            'Karışımlar: homojen ve heterojen',
            'Element: tek tür atomdan oluşur (ör: demir, altın)',
            'Bileşik: farklı atom türlerinin belirli oranda birleşmesiyle oluşur (ör: su H₂O)',
          ],
        ),
        StudySection(
          heading: 'Maddenin Halleri',
          body:
              'Madde katı, sıvı ve gaz olmak üzere üç halde bulunur. '
              'Isı alarak katı → sıvı → gaz dönüşümü yaşanır. '
              'Isı vererek gaz → sıvı → katı dönüşümü yaşanır.',
          keyPoints: [
            'Erime: katı → sıvı (ısı alır)',
            'Donma: sıvı → katı (ısı verir)',
            'Buharlaşma: sıvı → gaz (ısı alır)',
            'Yoğunlaşma: gaz → sıvı (ısı verir)',
            'Süblimleşme: katı → gaz (direkt)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Atom ve Periyodik Tablo',
      emoji: '⚛️',
      sections: [
        StudySection(
          heading: 'Atomun Yapısı',
          body:
              'Atom; çekirdek ve çekirdeğin etrafındaki elektronlardan oluşur. '
              'Çekirdekte proton (+) ve nötron (0) bulunur. '
              'Proton sayısı atomun kimliğini belirler; buna atom numarası denir.',
          keyPoints: [
            'Proton sayısı = atom numarası',
            'Proton + Nötron = kütle numarası',
            'Elektron sayısı = proton sayısı (nötr atomda)',
            'İzotoplar: proton sayısı aynı, nötron sayısı farklı atomlar',
          ],
        ),
        StudySection(
          heading: 'Periyodik Tablo',
          body:
              'Elementler atom numaralarına göre sıralandığı tabloya periyodik tablo denir. '
              'Tabloda 118 element bulunur. '
              'Yatay sıralar "periyot", dikey sütunlar "grup" olarak adlandırılır. '
              'Aynı gruptaki elementler benzer kimyasal özellikler gösterir.',
          keyPoints: [
            '118 element vardır',
            'Metaller, ametaller ve yarı metaller olarak sınıflandırılır',
            'Soygazlar (Grup 18): He, Ne, Ar — tepkimeye girmezler',
            'Halojenler (Grup 17): F, Cl, Br — çok reaktiftir',
            'Alkali metaller (Grup 1): Li, Na, K — suyla şiddetli tepkime',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Asitler, Bazlar ve pH',
      emoji: '🔬',
      sections: [
        StudySection(
          heading: 'Asit ve Baz Kavramları',
          body:
              'Asitler suda H⁺ iyonu oluşturan bileşiklerdir. Ekşi tat verir ve metalleri çözer. '
              'Bazlar suda OH⁻ iyonu oluşturan bileşiklerdir. Acı tat verir ve kaygan hissettirir.',
          keyPoints: [
            'Asit örnekleri: limon suyu, sirke, mide asidi (HCl)',
            'Baz örnekleri: sabun, çamaşır suyu, soda',
            'Asit + baz → tuz + su (nötrleşme tepkimesi)',
            'İndikatörler: pH ölçmek için kullanılır (turnusol, fenolftalein)',
          ],
        ),
        StudySection(
          heading: 'pH Skalası',
          body:
              'pH, maddenin asit veya baz gücünü gösteren 0-14 arası bir skaladır. '
              'pH 7 nötr (saf su), 7\'den küçük asit, 7\'den büyük bazdır.',
          keyPoints: [
            'pH < 7 → Asit (ör: limon suyu pH ≈ 2)',
            'pH = 7 → Nötr (saf su)',
            'pH > 7 → Baz (ör: çamaşır suyu pH ≈ 12)',
            'pH azaldıkça asit gücü artar',
            'pH arttıkça baz gücü artar',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Karışımlar',
      emoji: '🥤',
      sections: [
        StudySection(
          heading: 'Homojen ve Heterojen Karışımlar',
          body:
              'Homojen karışımlarda bileşenler her yerde eşit dağılmıştır, gözle ayırt edilemez. '
              'Heterojen karışımlarda bileşenler eşit dağılmamıştır, gözle görülebilir.',
          keyPoints: [
            'Homojen örnekler: tuzlu su, şekerli çay, hava',
            'Heterojen örnekler: kum+su, salata, granit',
            'Çözünen + Çözücü = Çözelti (homojen)',
            'Süzme, damıtma, kristalleştirme → karışım ayırma yöntemleri',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── BİYOLOJİ ───────────────────
  static const List<StudyTopic> _biology = [
    StudyTopic(
      title: 'Hücre',
      emoji: '🦠',
      sections: [
        StudySection(
          heading: 'Hücre Teorisi',
          body:
              'Tüm canlılar hücrelerden oluşur. Hücre, canlının en küçük yapı ve işlev birimidir. '
              'Tek hücreli canlılarda (bakteri, amip) bir hücre tüm yaşamsal görevleri yapar.',
          keyPoints: [
            'En küçük yaşam birimi: hücre',
            'Prokaryot hücre: çekirdeği yoktur (bakteri)',
            'Ökaryot hücre: gerçek çekirdeği vardır (bitki, hayvan, mantar)',
            'Bitki hücresi: hücre duvarı ve kloroplast içerir',
            'Hayvan hücresi: hücre duvarı yoktur',
          ],
        ),
        StudySection(
          heading: 'Hücre Organelleri',
          body:
              'Çekirdek: DNA\'yı taşır, kalıtım ve yönetim merkezi.\n'
              'Mitokondri: enerji üretir ("hücrenin güç santrali").\n'
              'Ribozom: protein sentezi yapar.\n'
              'Kloroplast: (bitkilerde) fotosentez yapar.\n'
              'Hücre Zarı: madde geçişini kontrol eder.',
          keyPoints: [
            'Çekirdek → kontrol merkezi',
            'Mitokondri → enerji üretimi (ATP)',
            'Ribozom → protein üretimi',
            'Kloroplast → fotosentez (sadece bitkilerde)',
            'Hücre zarı → seçici geçirgen',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Fotosentez ve Solunum',
      emoji: '🌿',
      sections: [
        StudySection(
          heading: 'Fotosentez',
          body:
              'Bitkiler, güneş ışığı enerjisini kullanarak su ve karbondioksiti glikoza dönüştürür. '
              'Bu süreç yapraklardaki kloroplastlarda gerçekleşir.\n\n'
              'Formül: CO₂ + H₂O + Işık → Glikoz + O₂',
          keyPoints: [
            'Ham maddeler: CO₂ (stomadan) ve H₂O (kökten)',
            'Enerji kaynağı: güneş ışığı',
            'Ürünler: glikoz (besin) ve O₂ (serbest bırakılır)',
            'Klorofil: ışığı emen yeşil pigment',
            'Yaprak: fotosentezin gerçekleştiği ana organ',
          ],
        ),
        StudySection(
          heading: 'Hücresel Solunum',
          body:
              'Tüm canlılar glikozu parçalayarak enerji (ATP) üretir. '
              'Bu süreç mitokondrida gerçekleşir.\n\n'
              'Formül: Glikoz + O₂ → CO₂ + H₂O + Enerji (ATP)',
          keyPoints: [
            'Tüm canlılarda gerçekleşir (bitkiler dahil)',
            'Mitokondrida gerçekleşir',
            'Glikozu parçalar → ATP üretir',
            'Fotosentezin tersidir',
            'Oksijen gerektirir (aerobik solunum)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Sindirim Sistemi',
      emoji: '🫃',
      sections: [
        StudySection(
          heading: 'Sindirim Organları',
          body:
              'Besinler ağızdan alınır ve adım adım parçalanarak kana geçirilir. '
              'Ağız → Yemek Borusu → Mide → İnce Bağırsak → Kalın Bağırsak → Anüs sıralamasıyla ilerler.',
          keyPoints: [
            'Ağız: mekanik ve kimyasal sindirim başlar (amilaz)',
            'Mide: protein sindirimi (pepsin + HCl)',
            'İnce Bağırsak: besinler kana geçer (emilim)',
            'Karaciğer: safra üretir (yağ sindirimi)',
            'Kalın Bağırsak: su emilimi, atık oluşur',
          ],
        ),
        StudySection(
          heading: 'Besin Grupları',
          body:
              'Karbonhidratlar: hızlı enerji kaynağı (ekmek, pirinç, şeker)\n'
              'Proteinler: büyüme ve onarım (et, yumurta, fasulye)\n'
              'Yağlar: uzun süreli enerji, vitamin taşıyıcı\n'
              'Vitaminler ve Mineraller: vücut düzenleme\n'
              'Su: tüm reaksiyonlar için gerekli',
          keyPoints: [
            'Karbonhidrat: temel enerji kaynağı',
            'Protein: yapı taşı (amino asitlerden oluşur)',
            'Yağ: enerji deposu ve hücre zarının yapısı',
            'Vitamin C eksikliği → skorbüt hastalığı',
            'Vitamin D eksikliği → raşitizm',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Dolaşım Sistemi',
      emoji: '❤️',
      sections: [
        StudySection(
          heading: 'Kalp ve Kan Damarları',
          body:
              'Kalp, kanı tüm vücuda pompalayan kas yapılı organdır. '
              'Dört odacığı vardır: iki kulakçık, iki karıncık. '
              'Arterler: kanı kalpten uzaklaştırır. Venler: kanı kalbe getirir. '
              'Kılcallar: en ince damarlardır, hücrelere madde alışverişi yapar.',
          keyPoints: [
            'Kalbin 4 odacığı var: 2 kulakçık + 2 karıncık',
            'Atardamar (arter): kalpten uzaklaşır, oksijence zengin',
            'Toplardamar (ven): kalbe gelir, CO₂\'ce zengin',
            'Kılcal damarlar: en incesi, besin/gaz alışverişi',
            'Aort: vücudun en büyük arteri',
          ],
        ),
        StudySection(
          heading: 'Kanın Bileşenleri',
          body:
              'Alyuvarlar (eritrosit): oksijen taşır, hemoglobin içerir, kırmızı renk.\n'
              'Akyuvarlar (lökosit): bağışıklık, mikroplarla savaşır.\n'
              'Trombositler: pıhtılaşmayı sağlar, yaraları kapatır.\n'
              'Plazma: kanın sıvı kısmı, besin ve hormon taşır.',
          keyPoints: [
            'Alyuvar: O₂ taşır (hemoglobin)',
            'Akyuvar: savunma görevi',
            'Trombosit: pıhtılaşma',
            'Plazma: kanın %55\'i, sıvı kısım',
            'Kan grupları: A, B, AB, 0',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Ekosistem ve Çevre',
      emoji: '🌍',
      sections: [
        StudySection(
          heading: 'Besin Zinciri',
          body:
              'Ekosistemde canlılar arasındaki besin ilişkisi bir zincir oluşturur. '
              'Üreticiler (bitkiler) → Otçullar (birincil tüketiciler) → '
              'Etçiller (ikincil tüketiciler) → Ayrıştırıcılar (bakteri, mantar).',
          keyPoints: [
            'Üretici: kendi besinini yapar (bitkiler)',
            'Tüketici: başka canlılarla beslenir',
            'Ayrıştırıcı: ölü organik maddeyi parçalar',
            'Besin ağı: birbiriyle kesişen besin zincirleri',
            'Enerji bir basamaktan diğerine geçerken azalır (%10 kuralı)',
          ],
        ),
        StudySection(
          heading: 'Çevre Sorunları',
          body:
              'İnsan faaliyetleri ekosistemleri tehdit etmektedir. '
              'Hava kirliliği, su kirliliği, orman tahribatı ve küresel ısınma '
              'başlıca çevre sorunlarıdır.',
          keyPoints: [
            'Sera etkisi: CO₂ ve diğer gazların ısıyı tutması',
            'Küresel ısınma: ortalama sıcaklıkların artması',
            'Ozon tabakası: UV ışınlarından korur',
            'Biyoçeşitlilik kaybı: türlerin yok olması',
            'Geri dönüşüm çevre korumada önemlidir',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── BİLGİSAYAR & PROGRAMLAMA ───────────────────
  static const List<StudyTopic> _cs = [
    StudyTopic(
      title: 'Bilgisayar Temelleri',
      emoji: '🖥️',
      sections: [
        StudySection(
          heading: 'Donanım ve Yazılım',
          body:
              'Donanım: bilgisayarın fiziksel parçalarıdır (ekran, klavye, fare, CPU, RAM).\n'
              'Yazılım: bilgisayara ne yapacağını söyleyen programlardır (Windows, Chrome, oyunlar).\n'
              'İşletim Sistemi: donanımı yönetir ve diğer programların çalışmasını sağlar.',
          keyPoints: [
            'CPU: işlemci, tüm hesapları yapar ("beyin")',
            'RAM: geçici bellek, açık programları tutar',
            'HDD/SSD: kalıcı depolama',
            'İşletim sistemi: Windows, macOS, Linux, Android',
            'Donanım olmadan yazılım çalışamaz',
          ],
        ),
        StudySection(
          heading: 'Sayı Sistemleri',
          body:
              'Bilgisayarlar her şeyi 0 ve 1\'lerle işler (binary/ikili sistem). '
              'Onluk sistem 10 rakam (0-9) kullanırken, ikili sistem sadece 0 ve 1 kullanır.',
          keyPoints: [
            'Binary (2\'lik): 0 ve 1 (bit)',
            '8 bit = 1 Byte',
            '1024 Byte = 1 KB',
            '1024 KB = 1 MB',
            'ASCII: her harfe sayısal kod verir (A = 65)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Algoritmalar ve Akış Şemaları',
      emoji: '🔄',
      sections: [
        StudySection(
          heading: 'Algoritma Nedir?',
          body:
              'Algoritma, bir problemi çözmek için izlenen adım adım talimatlardır. '
              'İyi bir algoritma net, sıralı, başlangıç ve bitişi belli olmalıdır. '
              'Günlük hayatta tarif, yemek tarifi gibi şeyler de birer algoritmadır.',
          keyPoints: [
            'Algoritma: sıralı, net adımlar dizisi',
            'Giriş → İşlem → Çıkış',
            'Döngüler: aynı işlemi tekrar eder',
            'Koşullar: "eğer ... ise" kararları',
            'Sıralama ve arama en temel algoritmalardır',
          ],
        ),
        StudySection(
          heading: 'Akış Şeması Sembolleri',
          body:
              'Oval/Yuvarlak uçlu dikdörtgen: Başlat/Bitir\n'
              'Dikdörtgen: İşlem (hesaplama)\n'
              'Eşkenar dörtgen: Karar (Evet/Hayır sorusu)\n'
              'Paralelkenar: Giriş/Çıkış\n'
              'Ok: akış yönü',
          keyPoints: [
            'Oval → Başla/Bitir',
            'Dikdörtgen → İşlem',
            'Eşkenar dörtgen → Karar (if-else)',
            'Paralelkenar → Giriş/Çıkış (al/yaz)',
            'Oklar → akış yönü gösterir',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Programlama Temelleri',
      emoji: '💻',
      sections: [
        StudySection(
          heading: 'Değişkenler ve Veri Türleri',
          body:
              'Değişken: program çalışırken veri saklamak için kullanılan isimlendirilmiş alan.\n'
              'Tam sayı (Integer): 5, -3, 100\n'
              'Ondalıklı sayı (Float/Double): 3.14, -0.5\n'
              'Metin (String): "Merhaba", "Türkiye"\n'
              'Mantıksal (Boolean): true veya false',
          keyPoints: [
            'int: tam sayı (1, 5, -10)',
            'double/float: ondalıklı sayı (3.14)',
            'String: metin ("merhaba")',
            'bool: doğru/yanlış (true/false)',
            'Değişken ismi anlamlı olmalı (yaş, ad, puan)',
          ],
        ),
        StudySection(
          heading: 'Koşullar ve Döngüler',
          body:
              'if-else: koşula göre farklı işlem yapar.\n'
              '"Eğer not >= 50 ise Geçti, değilse Kaldı"\n\n'
              'for döngüsü: belli sayıda tekrar eder.\n'
              'while döngüsü: koşul doğru olduğu sürece tekrar eder.',
          keyPoints: [
            'if (koşul) → koşul doğruysa çalışır',
            'else → koşul yanlışsa çalışır',
            'for → belirli sayıda döngü',
            'while → koşul sağlandıkça döngü',
            'Sonsuz döngüye dikkat: program kilitlenir',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'İnternet ve Siber Güvenlik',
      emoji: '🔐',
      sections: [
        StudySection(
          heading: 'İnternet Nasıl Çalışır?',
          body:
              'İnternet, milyonlarca bilgisayarın birbiriyle bağlı olduğu küresel bir ağdır. '
              'Her cihazın benzersiz bir IP adresi vardır. '
              'DNS, alan adlarını (google.com) IP adreslerine çevirir.',
          keyPoints: [
            'IP adresi: cihazın internet kimliği (ör: 192.168.1.1)',
            'DNS: alan adı → IP adres çevirisi',
            'HTTP/HTTPS: web sayfası protokolü (S = güvenli)',
            'Router: ev/okul ağını internete bağlar',
            'Bulut (Cloud): internet üzerinde dosya depolama',
          ],
        ),
        StudySection(
          heading: 'Siber Güvenlik',
          body:
              'Güçlü şifre: büyük/küçük harf, rakam ve özel karakter içermeli, en az 8 karakter.\n'
              'Phishing: sahte e-posta/site ile kişisel bilgi çalmak.\n'
              'Virüs: bilgisayara zarar veren kötü amaçlı yazılım.',
          keyPoints: [
            'Güçlü şifre: büyük+küçük harf + rakam + özel karakter',
            'Her hesap için farklı şifre kullan',
            'Phishing: şüpheli bağlantılara tıklama',
            'Antivirüs yazılımı kullan',
            'Kişisel bilgilerini internette paylaşma',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── İNGİLİZCE ───────────────────
  static const List<StudyTopic> _english = [
    StudyTopic(
      title: 'Present Tense (Geniş Zaman)',
      emoji: '📅',
      sections: [
        StudySection(
          heading: 'Simple Present Tense',
          body:
              'Genel doğrular, alışkanlıklar ve tekrar eden olaylar için kullanılır.\n\n'
              'Olumlu: I/You/We/They + fiil, He/She/It + fiil-s/es\n'
              'Olumsuz: do not (don\'t) / does not (doesn\'t) + fiil\n'
              'Soru: Do/Does + özne + fiil?',
          keyPoints: [
            'He/She/It için fiile -s/-es eklenir',
            '"She plays" ✅, "She play" ❌',
            'Sıklık zarfları: always, usually, often, sometimes, rarely, never',
            'I go to school every day. (Her gün okula giderim.)',
            'She doesn\'t like spicy food. (Baharatlı yemekten hoşlanmaz.)',
          ],
        ),
        StudySection(
          heading: 'Present Continuous Tense',
          body:
              'Şu an yapılmakta olan eylemler için kullanılır.\n\n'
              'Yapısı: am/is/are + fiil-ing\n\n'
              'I am studying. (Şu an çalışıyorum.)\n'
              'She is reading a book. (Kitap okuyor.)',
          keyPoints: [
            'am/is/are + V-ing',
            'I am, He/She/It is, We/You/They are',
            'Şu an oluyor: "now", "right now", "at the moment"',
            '"He is swimming." → Şu an yüzüyor.',
            'Olumsuz: He is NOT swimming.',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Past Tense (Geçmiş Zaman)',
      emoji: '⏪',
      sections: [
        StudySection(
          heading: 'Simple Past Tense',
          body:
              'Geçmişte tamamlanan eylemler için kullanılır.\n\n'
              'Düzenli fiiller: fiile -d/-ed eklenir\n'
              'walk → walked, play → played, watch → watched\n\n'
              'Düzensiz fiiller: özel biçim alır\n'
              'go → went, come → came, see → saw, eat → ate',
          keyPoints: [
            'Düzenli: fiil + -ed (walked, played)',
            'Düzensiz: özel form (went, came, saw)',
            'Olumsuz: didn\'t + fiil (I didn\'t go)',
            'Soru: Did + özne + fiil? (Did you eat?)',
            'Zaman ifadeleri: yesterday, last week, in 2020, ago',
          ],
        ),
        StudySection(
          heading: 'Sık Kullanılan Düzensiz Fiiller',
          body:
              'be → was/were\ngo → went\ncome → came\ndo → did\nhave → had\n'
              'see → saw\neat → ate\ngive → gave\ntake → took\nbuy → bought\n'
              'write → wrote\nread → read\nsay → said\nthink → thought',
          keyPoints: [
            'be → was (tekil) / were (çoğul)',
            'go → went (gitti)',
            'come → came (geldi)',
            'have → had (sahipti)',
            'see → saw (gördü)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Future Tense (Gelecek Zaman)',
      emoji: '⏩',
      sections: [
        StudySection(
          heading: 'Will ile Gelecek Zaman',
          body:
              'Anlık kararlar, tahminler ve söz vermek için "will" kullanılır.\n\n'
              'Olumlu: will + fiil\n'
              'I will help you. (Sana yardım edeceğim.)\n\n'
              'Olumsuz: will not (won\'t) + fiil\n'
              'Soru: Will + özne + fiil?',
          keyPoints: [
            'will + fiil (tüm özneler için aynı)',
            'Olumsuz: won\'t (will not)',
            'Anlık karar: "I\'ll open the window."',
            'Tahmin: "It will rain tomorrow."',
            'Söz: "I will call you later."',
          ],
        ),
        StudySection(
          heading: 'Going To ile Gelecek Zaman',
          body:
              'Önceden planlanmış niyetler ve tahminler için "be going to" kullanılır.\n\n'
              'I am going to study tonight. (Bu gece çalışmayı planlıyorum.)\n'
              'She is going to visit her grandmother. (Büyükannesini ziyaret etmeyi planlıyor.)',
          keyPoints: [
            'am/is/are + going to + fiil',
            'Plan veya niyet: "I\'m going to learn coding."',
            'Kanıta dayalı tahmin: "Look at those clouds, it\'s going to rain."',
            '"going to" = önceden planlanmış',
            '"will" = anlık karar',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Gramer Yapıları',
      emoji: '📚',
      sections: [
        StudySection(
          heading: 'Countable & Uncountable Nouns',
          body:
              'Sayılabilir isimler: adet belirtilebilir, çoğul yapılabilir\n'
              'book → books, apple → apples, cat → cats\n\n'
              'Sayılamaz isimler: adet belirtilmez, çoğul yapılmaz\n'
              'water, milk, sugar, rice, money, information',
          keyPoints: [
            'Sayılabilir: a book, two books',
            'Sayılamaz: some water (NOT "a water")',
            'many → sayılabilir çoğul (many students)',
            'much → sayılamaz (much water)',
            'a lot of → her ikisi için',
          ],
        ),
        StudySection(
          heading: 'Sıfatların Karşılaştırma Dereceleri',
          body:
              'Eşitlik: as + sıfat + as → "She is as tall as me."\n'
              'Üstünlük: sıfat + -er + than → "He is taller than her."\n'
              'En üstünlük: the + sıfat + -est → "She is the tallest in class."\n\n'
              'Uzun sıfatlar: more/most kullanılır\n'
              'beautiful → more beautiful → the most beautiful',
          keyPoints: [
            'Short adj: tall → taller → tallest',
            'Long adj: beautiful → more beautiful → most beautiful',
            'Düzensiz: good → better → best',
            'Düzensiz: bad → worse → worst',
            'Düzensiz: far → farther → farthest',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Temel Kelime Bilgisi',
      emoji: '🔤',
      sections: [
        StudySection(
          heading: 'Okul ve Günlük Hayat',
          body:
              'School subjects: Math (Matematik), Science (Fen), History (Tarih), '
              'Art (Sanat), Music (Müzik), PE (Beden Eğitimi)\n\n'
              'Classroom objects: board (tahta), pencil (kalem), ruler (cetvel), '
              'notebook (defter), backpack (sırt çantası)',
          keyPoints: [
            'Days: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday',
            'Months: January, February... December',
            'Seasons: Spring (İlkbahar), Summer (Yaz), Autumn (Sonbahar), Winter (Kış)',
            'Colors: red, blue, green, yellow, purple, orange, pink, brown, black, white',
            'Numbers: one, two... twenty, thirty, forty, fifty, hundred, thousand',
          ],
        ),
        StudySection(
          heading: 'Edatlar (Prepositions)',
          body:
              'Zaman edatları:\n'
              'at: belirli saat (at 3 o\'clock)\n'
              'on: gün/tarih (on Monday, on July 4th)\n'
              'in: ay/yıl/mevsim (in summer, in 2025)\n\n'
              'Yer edatları:\n'
              'in: içinde (in the box), on: üzerinde (on the table), '
              'under: altında, next to: yanında, between: arasında',
          keyPoints: [
            'at → saat için (at 5 pm)',
            'on → gün/tarih için (on Monday)',
            'in → ay/yıl/mevsim için (in July)',
            'in / on / under / next to / between → yer',
            '"I live IN Istanbul" ✅ (şehir için "in")',
          ],
        ),
      ],
    ),
  ];
}
