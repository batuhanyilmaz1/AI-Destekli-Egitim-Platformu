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
    'fen': _fen,
    'cs': _cs,
    'english': _english,
    'math': _math,
    'turkish': _turkish,
    'history': _history,
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
    StudyTopic(
      title: 'Basınç ve Kaldırma Kuvveti',
      emoji: '💧',
      sections: [
        StudySection(
          heading: 'Basınç Nedir?',
          body: 'Basınç, birim alana uygulanan kuvvettir. '
              'Formülü: P = F / A (Kuvvet / Alan). '
              'Birimi Pascal (Pa)\'dır. '
              'Keskin aletlerin sivri ucu küçük alana yayıldığı için büyük basınç oluşturur.',
          keyPoints: [
            'Basınç formülü: P = F / A',
            'Basınç birimi: Pascal (Pa)',
            'Alan küçülünce basınç artar, alan büyüyünce basınç azalır',
            'Kar ayakkabıları alanı büyütür → basıncı azaltır',
            'Keskin bıçak alanı küçük → basınç yüksek',
          ],
        ),
        StudySection(
          heading: 'Sıvılarda Basınç ve Kaldırma Kuvveti',
          body: 'Sıvı basıncı derinlikle artar. '
              'Kaldırma kuvveti (Arşimet Prensibi): Bir cismin sıvıya batırdığında, '
              'sıvının cisim tarafından itilen kısmının ağırlığına eşit bir kuvvet yukarı doğru etki eder. '
              'Bu yüzden gemiler ve balıklar yüzer.',
          keyPoints: [
            'Sıvı basıncı: P = d × g × h (yoğunluk × yerçekimi × derinlik)',
            'Derinlik arttıkça sıvı basıncı artar',
            'Arşimet Prensibi: kaldırma kuvveti = sıvının itilen kısmının ağırlığı',
            'Yüzme koşulu: cismin yoğunluğu < sıvının yoğunluğu',
            'Batma koşulu: cismin yoğunluğu > sıvının yoğunluğu',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Isı ve Sıcaklık',
      emoji: '🌡️',
      sections: [
        StudySection(
          heading: 'Isı ile Sıcaklığın Farkı',
          body: 'Sıcaklık, bir cismin sıcaklık derecesidir; termometreyle ölçülür. '
              'Isı ise iki cisim arasında sıcaklık farkı nedeniyle aktarılan enerjidir. '
              'Sıcaktan soğuğa doğru ısı transferi olur.',
          keyPoints: [
            'Sıcaklık birimi: Celsius (°C) veya Kelvin (K)',
            'Isı birimi: Joule (J) veya kalori (cal)',
            'Isı her zaman sıcaktan soğuğa akar',
            'İletim: katılarda temas yoluyla ısı transferi',
            'Taşınım: sıvı ve gazlarda akışla ısı transferi',
            'Işıma: boşlukta ısı transferi (güneşten gelen ısı)',
          ],
        ),
        StudySection(
          heading: 'Genleşme',
          body: 'Maddeler ısındıkça genleşir (hacmi büyür), soğudukça büzülür. '
              'Bu özellik termometrelerde, köprü genleşme derzlerinde ve ısıtma sistemlerinde kullanılır.',
          keyPoints: [
            'Isınan maddeler genleşir, soğuyanlar büzülür',
            'Gazlar en çok genleşir, katılar en az',
            'Köprü derzi: sıcakta genleşmeyi karşılamak için bırakılır',
            'Bimetal: farklı genleşen iki metal şerit (termostatlar)',
            'Su 4°C\'de en yoğundur, buz sudan daha az yoğundur',
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
            'Süzme: boyut farkına göre katı-sıvı ayrımı',
            'Damıtma: kaynama noktası farkına göre sıvı-sıvı ayrımı',
            'Mıknatısla ayırma: demir gibi manyetik maddeleri ayrıştırır',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Kimyasal Tepkimeler',
      emoji: '💥',
      sections: [
        StudySection(
          heading: 'Fiziksel ve Kimyasal Değişim',
          body: 'Fiziksel değişimde maddenin kimyasal yapısı değişmez, sadece görünümü değişir. '
              'Kimyasal değişimde yeni bir madde oluşur ve bu değişim geri döndürülemez. '
              'Demir paslanması ve yanma kimyasal değişimlere örnektir.',
          keyPoints: [
            'Fiziksel değişim: şekil/hal değişimi, kimyasal yapı aynı kalır',
            'Kimyasal değişim: yeni madde oluşur',
            'Kimyasal değişim belirtileri: renk değişimi, gaz çıkışı, çökelti, ısı/ışık',
            'Yanma: yakıt + oksijen → CO₂ + H₂O + ısı',
            'Kütle korunumu yasası: tepkime öncesi = tepkime sonrası toplam kütle',
          ],
        ),
        StudySection(
          heading: 'Oksijenli ve Oksijensiz Yanma',
          body: 'Yanma, bir maddenin oksijenle birleşerek ısı ve ışık vermesidir. '
              'Tam yanmada CO₂ ve H₂O oluşur. Eksik yanmada zehirli CO (karbon monoksit) çıkabilir.',
          keyPoints: [
            'Yanma üçgeni: yakıt + oksijen + ateşleme sıcaklığı',
            'Tam yanma ürünleri: CO₂ ve H₂O',
            'Eksik yanma: CO (karbonmonoksit) oluşur — zehirlidir',
            'Yangın söndürme: üçgenin bir elemanını kaldır',
            'Pas: demirin oksijeniyle yavaş tepkimesi',
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
    StudyTopic(
      title: 'Solunum ve Boşaltım',
      emoji: '🫁',
      sections: [
        StudySection(
          heading: 'Solunum Sistemi',
          body: 'Solunum sistemi; burun, gırtlak, trakea, bronşlar ve akciğerlerden oluşur. '
              'Alveol: akciğerlerdeki küçük hava kesecikleri, gaz alışverişinin yapıldığı yerdir. '
              'Oksijen kana geçer, karbondioksit dışarı atılır.',
          keyPoints: [
            'Solunum yolu sırası: burun → yutak → gırtlak → soluk borusu → bronşlar → akciğerler',
            'Alveol: gaz alışverişinin gerçekleştiği yer',
            'Diyafram: solunumu sağlayan kas',
            'İç solunum: kanda O₂ ile CO₂ alışverişi',
            'Dış solunum: akciğer ile hava arasındaki gaz alışverişi',
          ],
        ),
        StudySection(
          heading: 'Boşaltım Sistemi',
          body: 'Boşaltım sistemi metabolizma artıklarını vücuttan uzaklaştırır. '
              'Böbrekler kandan üreyi süzerek idrar oluşturur. '
              'Deri ter ile, akciğerler CO₂ ile boşaltım yapar.',
          keyPoints: [
            'Böbrek: kanı filtreler, idrar üretir',
            'Üre: protein metabolizmasının son ürünü',
            'Nefron: böbreğin süzme birimidir',
            'Deri: ter yoluyla su, tuz ve üre atar',
            'Akciğer: CO₂ ve su buharı atar',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Kalıtım ve Üreme',
      emoji: '🧬',
      sections: [
        StudySection(
          heading: 'Kalıtım Temelleri',
          body: 'Kalıtım, özelliklerin anne-babadan çocuğa aktarılmasıdır. '
              'Gen: belirli bir özelliği taşıyan DNA parçası. '
              'Kromozom: genlerin bulunduğu yapı. '
              'İnsanda 46 kromozom (23 çift) bulunur; 23\'ü anneden, 23\'ü babadan gelir.',
          keyPoints: [
            'Gen: kalıtımın birimi, DNA parçası',
            'Kromazom: genleri taşıyan yapı',
            'İnsanda 46 kromozom = 23 çift',
            'Baskın gen: etkisini her durumda gösterir',
            'Çekinik gen: iki kopya gerekir etkisini göstermek için',
          ],
        ),
        StudySection(
          heading: 'Eşeyli ve Eşeysiz Üreme',
          body: 'Eşeysiz üremede sadece bir ebeveyn vardır; yavru genetik kopyasıdır. '
              'Eşeyli üremede iki ebeveyn vardır; yavru her ikisinden özellik alır. '
              'Bakteri bölünme, bitkilerin çelikle çoğalması eşeysiz üreme örnekleridir.',
          keyPoints: [
            'Eşeysiz üreme: tek ebeveyn, genetik özdeş yavru',
            'Eşeyli üreme: iki ebeveyn, yavru farklı özellikler taşır',
            'Mitoz: büyüme ve onarım için hücre bölünmesi',
            'Mayoz: üreme hücrelerinin (yumurta, sperm) üretimi',
            'Çiçeklenme ve tohumlanma bitkilerde eşeyli üremenin parçasıdır',
          ],
        ),
      ],
    ),
  ];

  /// Fizik + Kimya + Biyoloji — tek Fen Bilimleri çatısı (çalışma kitabı).
  static const List<StudyTopic> _fen = [
    ..._physics,
    ..._chemistry,
    ..._biology,
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
    StudyTopic(
      title: 'Modal Fiiller',
      emoji: '🗣️',
      sections: [
        StudySection(
          heading: 'Can / Could / Will / Would',
          body: 'Modal fiiller yardımcı fiillerdir ve asıl fiilin önüne gelir. '
              '"Can" yetenek veya izin için kullanılır. '
              '"Will" gelecek zaman için. "Would" nazik istek için.',
          keyPoints: [
            'can → yetenek/izin (I can swim. Can I help?)',
            'could → geçmiş yetenek veya nazik istek (Could you help me?)',
            'will → gelecek zaman (I will go tomorrow)',
            'would → nazik istek/koşullu (I would like a tea)',
            'must → zorunluluk (You must wear a seatbelt)',
            'should → tavsiye (You should study more)',
          ],
        ),
        StudySection(
          heading: 'Must / Should / May / Might',
          body: '"Must" zorunluluk ifade eder. '
              '"Should" tavsiye verir. '
              '"May/Might" olasılık bildirir.',
          keyPoints: [
            'must → zorunluluk (I must finish this)',
            'must not → yasak (You must not run here)',
            'should → tavsiye (You should eat breakfast)',
            'may → izin/olasılık (May I come in?)',
            'might → düşük olasılık (It might rain today)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Karşılaştırma',
      emoji: '🔄',
      sections: [
        StudySection(
          heading: 'Comparative & Superlative',
          body: 'Sıfatların karşılaştırma biçimleri İngilizcede önemlidir. '
              'Kısa sıfatlara "-er / -est" eklenir. '
              'Uzun sıfatlar "more / most" alır.',
          keyPoints: [
            'Kısa sıfat + -er: tall → taller (daha uzun)',
            'Kısa sıfat + -est: tall → tallest (en uzun)',
            'Uzun sıfat: more beautiful / most beautiful',
            'Düzensizler: good → better → best',
            'Düzensizler: bad → worse → worst',
            '"as … as" → eşitlik karşılaştırması (as tall as)',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── MATEMATİK ───────────────────
  static const List<StudyTopic> _math = [
    StudyTopic(
      title: 'Sayılar ve İşlemler',
      emoji: '🔢',
      sections: [
        StudySection(
          heading: 'Doğal Sayılar',
          body: 'Sıfır ve pozitif tam sayılara doğal sayılar denir. '
              '0, 1, 2, 3, 4, … şeklinde devam eder. '
              'Toplama, çıkarma, çarpma ve bölme işlemleri dört temel işlemdir. '
              'Bölmede bölen hiçbir zaman 0 olamaz.',
          keyPoints: [
            'Doğal sayılar: 0, 1, 2, 3, …',
            'Çift sayılar 2\'ye tam bölünür: 2, 4, 6, 8…',
            'Tek sayılar 2\'ye bölünmez: 1, 3, 5, 7…',
            'Sıfırla çarpım her zaman 0\'dır',
            'Bir sayıyı 0\'a bölmek tanımsızdır',
          ],
        ),
        StudySection(
          heading: 'Kesirler',
          body: 'Kesirler bir bütünün parçalarını gösterir. '
              'Pay / Payda şeklinde yazılır. '
              'Örneğin 3/4 → bütünü 4 eşit parçaya böldük, 3 tanesini aldık. '
              'Aynı paydaya sahip kesirler doğrudan toplanır/çıkarılır. '
              'Farklı paydalı kesirleri toplamak için önce ortak payda bulunur.',
          keyPoints: [
            'Pay: kesrin üstü, Payda: kesrin altı',
            'Denk kesir: pay ve paydayı aynı sayıyla çarp/böl',
            'Ortak payda → OKEK ile bulunur',
            'Kesir × Kesir = (pay×pay) / (payda×payda)',
            'Tam sayı × kesir: tam sayıyı paya yaz',
          ],
        ),
        StudySection(
          heading: 'Ondalık Sayılar',
          body: 'Ondalık sayılar virgülden sonra ondalık basamaklar içerir. '
              '3,14 → 3 tam, 14 yüzde. '
              'Ondalık sayıların toplanmasında virgüller alt alta yazılır. '
              'Yüzde: "yüzde 25" = 25/100 = 0,25',
          keyPoints: [
            '0,1 = 1/10 | 0,01 = 1/100 | 0,001 = 1/1000',
            'Toplama-çıkarmada virgülleri hizala',
            'Çarpmada sonuçtaki ondalık basamak = her iki sayının toplam basamağı',
            '%25 = 25/100 = 0,25',
            'Yüzde artış: Esas × (1 + oran)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Cebir ve Denklemler',
      emoji: '🔣',
      sections: [
        StudySection(
          heading: 'Değişkenler ve İfadeler',
          body: 'Cebirde bilinmeyen değerleri harflerle gösteririz. '
              'Örneğin x + 5 = 12 denkleminde x bilinmeyendir. '
              'Terim: değişken veya sabit sayı. '
              'Benzer terimleri toplayabiliriz: 3x + 2x = 5x.',
          keyPoints: [
            'Değişken: bilinmeyen sayıyı temsil eden harf (x, y, a…)',
            'Katsayı: değişkenin önündeki sayı (3x\'de katsayı 3)',
            'Sabit: sayı terim (5, -7, 2/3…)',
            'Benzer terimler: aynı değişkene sahip terimler',
            '3x + 2x = 5x | 3x + 2y topranamaz',
          ],
        ),
        StudySection(
          heading: 'Birinci Derece Denklemler',
          body: 'Bir bilinmeyenli birinci derece denklem ax + b = c biçimindedir. '
              'Çözmek için her iki tarafa aynı işlemi uygulamalıyız. '
              'Örnek: 2x + 3 = 11 → 2x = 8 → x = 4.',
          keyPoints: [
            'Denklemi çözerken her iki tarafı da etkile',
            '2x + 3 = 11 → 2x = 8 → x = 4',
            'Parantez önce açılır: 2(x+3) = 2x + 6',
            'Kontrol: x değerini denkleme yerleştir',
            'Sonuç küme: {4} gibi gösterilir',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Geometri',
      emoji: '📐',
      sections: [
        StudySection(
          heading: 'Temel Şekiller',
          body: 'Kare, dikdörtgen, üçgen ve daire temel geometrik şekillerdir. '
              'Kare: 4 eşit kenar, 4 dik açı. Alan = a². Çevre = 4a. '
              'Dikdörtgen: karşılıklı kenarlar eşit. Alan = a×b. Çevre = 2(a+b). '
              'Üçgen: 3 kenar. Alan = (taban × yükseklik) / 2.',
          keyPoints: [
            'Kare: Alan = a², Çevre = 4a',
            'Dikdörtgen: Alan = a×b, Çevre = 2(a+b)',
            'Üçgen: Alan = (t×h)/2',
            'Daire: Alan = π×r², Çevre = 2×π×r',
            'π ≈ 3,14',
          ],
        ),
        StudySection(
          heading: 'Açılar',
          body: 'Açı iki ışının ortak noktasından oluşur. '
              'Dar açı: 0° ile 90° arasında. '
              'Dik açı: tam 90°. '
              'Geniş açı: 90° ile 180° arasında. '
              'Doğrusal açı: 180°. Tam açı: 360°.',
          keyPoints: [
            'Dar açı: 0° < açı < 90°',
            'Dik açı: 90°',
            'Geniş açı: 90° < açı < 180°',
            'Bir üçgenin iç açıları toplamı = 180°',
            'Tamamlayıcı açılar toplamı = 90°',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Oran ve Orantı',
      emoji: '⚖️',
      sections: [
        StudySection(
          heading: 'Oran Nedir?',
          body: 'Oran, iki sayının birbirine bölümüdür. a/b şeklinde yazılır (b ≠ 0). '
              'Orantı ise iki oranın birbirine eşit olmasıdır: a/b = c/d.',
          keyPoints: [
            'Oran: a/b (iki büyüklüğün karşılaştırılması)',
            'Orantı: a/b = c/d (iki oranın eşitliği)',
            'Doğru orantı: bir büyüklük artınca diğeri de artar',
            'Ters orantı: bir büyüklük artınca diğeri azalır',
            'Oran-orantı problemleri: hız, zaman, fiyat, nüfus hesaplarında kullanılır',
          ],
        ),
        StudySection(
          heading: 'Yüzde (%) Hesabı',
          body: 'Yüzde, bir sayının 100 üzerinden ifadesidir. '
              '% işareti "yüzde" anlamına gelir. '
              'Yüzde hesaplamaları indirim, faiz ve istatistik problemlerinde sıkça kullanılır.',
          keyPoints: [
            '%25 = 25/100 = 0,25',
            'Yüzde artış: (artış / başlangıç) × 100',
            'Yüzde azalış: (azalış / başlangıç) × 100',
            'İndirim: yeni fiyat = orijinal × (1 − oran)',
            'Zam: yeni fiyat = orijinal × (1 + oran)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Veri ve Olasılık',
      emoji: '📊',
      sections: [
        StudySection(
          heading: 'Veri Analizi',
          body: 'Veri analizi, toplanan sayısal bilgileri anlamlandırmak için kullanılır. '
              'Ortalama, ortanca ve tepe değer; verileri özetleyen ölçülerdir.',
          keyPoints: [
            'Ortalama (Aritmetik): veriler toplamı / veri sayısı',
            'Ortanca (Medyan): sıralı dizinin ortasındaki değer',
            'Tepe değer (Mod): en çok tekrar eden değer',
            'Ranj: en büyük − en küçük değer',
            'Sütun grafiği, çizgi grafiği, pasta grafiği veri görselleştirme araçlarıdır',
          ],
        ),
        StudySection(
          heading: 'Temel Olasılık',
          body: 'Olasılık, bir olayın gerçekleşme şansının sayısal ifadesidir. '
              '0 ile 1 arasında değer alır. 0: imkânsız, 1: kesin.',
          keyPoints: [
            'Olasılık = İstenen durum sayısı / Toplam durum sayısı',
            'Olasılık 0 ile 1 arasındadır',
            '0: imkânsız, 1: kesin olay',
            'Bir sikke atıldığında yazı gelme olasılığı: 1/2',
            'Bir zarın 3 gelme olasılığı: 1/6',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── TÜRKÇE ───────────────────
  static const List<StudyTopic> _turkish = [
    StudyTopic(
      title: 'Ses Bilgisi',
      emoji: '🔤',
      sections: [
        StudySection(
          heading: 'Sesli ve Sessiz Harfler',
          body: 'Türkçede 8 sesli (ünlü), 21 sessiz (ünsüz) harf vardır. '
              'Sesli harfler: a, e, ı, i, o, ö, u, ü. '
              'Ünlü uyumu: Kalınlık uyumu ve incelik uyumu olmak üzere ikiye ayrılır. '
              'Kalın ünlüler: a, ı, o, u | İnce ünlüler: e, i, ö, ü.',
          keyPoints: [
            'Sesli harfler: a e ı i o ö u ü (8 tane)',
            'Kalın ünlüler: a ı o u',
            'İnce ünlüler: e i ö ü',
            'Büyük ünlü uyumu: son ekte önceki sesliye uy',
            'Küçük ünlü uyumu: e/a ve i/ı/ü/u ayrımı',
          ],
        ),
        StudySection(
          heading: 'Hece ve Heceleme',
          body: 'Hece, bir solukta çıkarılan ses topluluğudur. '
              'Her hece mutlaka bir sesli harf içerir. '
              'Türkçede bir kelime okunuşa göre hecelerine ayrılır. '
              'Örnek: "ka-lem", "öğ-ren-ci", "yıl-dız".',
          keyPoints: [
            'Her hece en az bir sesli harf içerir',
            'ka-lem: 2 hece | öğ-ren-ci: 3 hece',
            'Hece sayısı = sesli harf sayısı',
            'Satır sonunda kelime hecelerine göre bölünür',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Dil Bilgisi',
      emoji: '✏️',
      sections: [
        StudySection(
          heading: 'İsimler (Adlar)',
          body: 'İsimler varlıkları, kavramları ve durumları karşılayan sözcüklerdir. '
              'Özel isimler (kişi, yer, kurum adları) büyük harfle başlar: Ankara, Mehmet. '
              'Cins isimler genel varlıkları bildirir: kalem, kitap, araba.',
          keyPoints: [
            'Özel isim: belirli bir varlık → büyük harfle (Türkiye, Ali)',
            'Cins isim: genel kavram → küçük harfle (şehir, öğrenci)',
            'Soyut isim: gözle görülmez (sevgi, cesaret)',
            'Somut isim: duyularla algılanır (masa, elma)',
            'Topluluk ismi: tek görünüm, çok anlam (sürü, orman)',
          ],
        ),
        StudySection(
          heading: 'Fiiller',
          body: 'Fiiller eylem, oluş veya durum bildiren sözcüklerdir. '
              'Geniş zaman eki: -(a/e)r veya -ır/ir/ur/ür. '
              'Geçmiş zaman eki: -dı/di/du/dü (görülen) ya da -mış/miş (öğrenilen). '
              'Şimdiki zaman eki: -ıyor/iyor/uyor/üyor.',
          keyPoints: [
            'Şimdiki zaman: -ıyor (gidiyorum)',
            'Görülen geçmiş: -dı/di (gittim)',
            'Öğrenilen geçmiş: -mış/miş (gitmiş)',
            'Geniş zaman: -ar/er (gider)',
            'Gelecek zaman: -acak/ecek (gidecek)',
          ],
        ),
        StudySection(
          heading: 'Yazım Kuralları',
          body: 'Büyük harf: cümle başı, özel isimler, unvanlar. '
              'Nokta: cümle sonu, kısaltmalar. '
              'Virgül: sıralama, bağlaçsız sıralama, uzun cümlelerde bölme. '
              'Kesme işareti: özel isimlere gelen ekler (Ankara\'ya, Mehmet\'in).',
          keyPoints: [
            'Özel isimlere gelen ekler kesme işaretiyle ayrılır',
            'Saat aralarında nokta: 14.30 (saat 14\'te 30 dakika)',
            'Virgül: "Ahmet, Mehmet ve Ali geldi."',
            '"de / da" ayrı yazılır (bağlaç), "de" bitişik (ek)',
            '"ki" çoğunlukla ayrı yazılır (ama "çünkü" bitişik)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Anlam Bilgisi',
      emoji: '💬',
      sections: [
        StudySection(
          heading: 'Sözcükte Anlam',
          body: 'Gerçek anlam: sözcüğün ilk ve temel anlamı. '
              'Mecaz anlam: gerçek anlamından uzaklaşarak kazanılan anlam. '
              'Örnek: "yürek" sözcüğü gerçek anlamda bir organ; "yürekli" ise cesur demektir. '
              'Terim anlam: bir bilim ya da meslek alanındaki özel anlam.',
          keyPoints: [
            'Gerçek anlam: sözlükteki ilk anlam',
            'Mecaz anlam: aktarılmış, eğretileme',
            'Terim anlam: bilim/sanat alanına özgü (ör. "fiil")',
            'Eş anlamlı: farklı ses, aynı anlam (güzel = yakışıklı)',
            'Zıt anlamlı: karşıt anlam (büyük ≠ küçük)',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Paragraf ve Metin Türleri',
      emoji: '📄',
      sections: [
        StudySection(
          heading: 'Paragraf Yapısı',
          body: 'Paragraf; giriş, gelişme ve sonuç cümlelerinden oluşur. '
              'Konu cümlesi paragrafın konusunu belirler. '
              'Destekleyici cümleler konuyu açar ve örnekler verir. '
              'Sonuç cümlesi ise paragrafı tamamlar.',
          keyPoints: [
            'Konu cümlesi: paragrafın ana fikri',
            'Ana fikir: yazarın okuyucuya vermek istediği mesaj',
            'Yardımcı fikir: ana fikri destekleyen cümleler',
            'Özet: metnin kısa anlatımı',
            'Başlık: metnin konusunu yansıtır',
          ],
        ),
        StudySection(
          heading: 'Yazı Türleri',
          body: 'Hikâye: kurgusal olayları anlatır. '
              'Makale: bir konuyu bilimsel/mantıksal ele alır. '
              'Şiir: duygusal ifadeleri ölçü ve uyakla aktarır. '
              'Fıkra: günlük hayattaki konuları kişisel bakış açısıyla yorumlar.',
          keyPoints: [
            'Hikâye: olay, kişi, yer, zaman içerir',
            'Makale: kanıt ve örneklere dayalı görüş yazısı',
            'Deneme: yazarın kişisel görüşlerini özgürce anlattığı tür',
            'Haber yazısı: 5N1K (ne, nerede, ne zaman, nasıl, neden, kim)',
            'Şiirde uyak: satır sonlarının ses benzerliği',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Noktalama ve Yazım',
      emoji: '✏️',
      sections: [
        StudySection(
          heading: 'Noktalama İşaretleri',
          body: 'Noktalama işaretleri anlamı ve tonlamayı belirler. '
              'Nokta: cümle sonu. Virgül: sıralama ve duraklama. '
              'Soru işareti: soru cümleleri. Ünlem: duygu cümleleri.',
          keyPoints: [
            'Nokta (.): bildirme cümlesi sonu',
            'Virgül (,): sıralama, duraklatma, yan cümle ayrımı',
            'Soru işareti (?): soru cümleleri',
            'Ünlem (!): duygu yoğunluğu, emir',
            'İki nokta (:): açıklama veya alıntı öncesi',
            'Tırnak işareti: alıntı veya özel kelime',
          ],
        ),
        StudySection(
          heading: 'Büyük Harf Kuralları',
          body: 'Türkçede büyük harf belirli kurallara göre kullanılır: '
              'Cümle başları, özel isimler, unvanlar ve kısaltmalar büyük harfle başlar.',
          keyPoints: [
            'Cümle başı daima büyük harfle başlar',
            'Özel isimler büyük harf: Atatürk, İstanbul, Türkiye',
            'Aylık ve günler küçük: ocak, pazartesi',
            'Yön adları küçük: kuzey, güney (özel isim değilse)',
            'Kısaltmalar büyük harfle: TDK, TC, TBMM',
          ],
        ),
      ],
    ),
  ];

  // ─────────────────── TARİH ───────────────────
  static const List<StudyTopic> _history = [
    StudyTopic(
      title: 'İlk Uygarlıklar',
      emoji: '🏺',
      sections: [
        StudySection(
          heading: 'Tarih Öncesi Dönemler',
          body: 'İnsanlık tarihini yazının kullanılıp kullanılmamasına göre ikiye ayırırız. '
              'Yazının icadından önceki döneme "Tarih Öncesi" (Prehistorya) denir. '
              'Taş Devri → Bakır Devri → Tunç Devri → Demir Devri olarak sıralanır. '
              'Yazı MÖ 3200 civarında Sümerler tarafından Mezopotamya\'da bulunmuştur.',
          keyPoints: [
            'Tarih Öncesi: yazıdan önce',
            'Tarih: yazının bulunmasıyla başlar (MÖ 3200)',
            'Taş Devri: Paleolitik → Mezolitik → Neolitik',
            'Neolitik\'te tarım ve hayvancılık başladı',
            'Yazıyı Sümerler buldu (çivi yazısı)',
          ],
        ),
        StudySection(
          heading: 'Mezopotamya Uygarlıkları',
          body: 'Mezopotamya "iki nehir arası" anlamına gelir (Dicle ve Fırat). '
              'Sümerler, Akadlar, Babiller ve Asurlular bu bölgede yaşadı. '
              'Hammurabi Kanunları dünyanın bilinen ilk yazılı hukuk sistemlerinden biridir. '
              'Zigguratlar tapınak olarak kullanılan basamaklı yapılardır.',
          keyPoints: [
            'Mezopotamya: Dicle ve Fırat nehirleri arası',
            'Sümerler: çivi yazısı, ilk şehir devletleri',
            'Hammurabi Kanunları: yazılı hukukun öncüsü',
            'Ziggurat: basamaklı tapınak',
            'Babil: Asma Bahçeler, yedi harikadan biri',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Türk Tarihi',
      emoji: '🐺',
      sections: [
        StudySection(
          heading: 'İlk Türk Devletleri',
          body: 'Türklerin anayurdu Orta Asya\'dır. '
              'Büyük Hun Devleti (MÖ 220) ilk büyük Türk devletidir, kurucusu Mete Han\'dır. '
              'Göktürkler ise Türk adını kullanan ilk devlettir ve kendi alfabelerini oluşturmuşlardır (Göktürk/Orhun alfabesi). '
              'Orhun Yazıtları Türklerin en eski yazılı belgeleridir.',
          keyPoints: [
            'İlk Türk devleti: Büyük Hun (MÖ 220) — Mete Han',
            'Türk adını kullanan ilk devlet: Göktürkler',
            'Orhun Yazıtları: en eski Türkçe yazılı belgeler',
            'Uygurlar: yerleşik hayata geçen ilk Türkler',
            'İslamiyet\'i kabul: Karahanlılar (X. yüzyıl)',
          ],
        ),
        StudySection(
          heading: 'Osmanlı Devleti',
          body: 'Osmanlı Devleti 1299\'da Osman Bey tarafından kuruldu. '
              '1453\'te Fatih Sultan Mehmet İstanbul\'u fethetti; böylece Orta Çağ sona erdi. '
              'Yavuz Sultan Selim döneminde Mısır alındı ve halifelik Osmanlılara geçti. '
              'Kanuni Sultan Süleyman döneminde devlet en geniş sınırlarına ulaştı. '
              'Osmanlı 1922\'de son buldu, yerine Türkiye Cumhuriyeti kuruldu.',
          keyPoints: [
            'Kuruluş: 1299 — Osman Bey',
            'İstanbul\'un fethi: 1453 — Fatih Sultan Mehmet',
            'Orta Çağ\'ın sonu: 1453 İstanbul\'un fethi',
            'En geniş sınırlar: Kanuni Sultan Süleyman',
            'Cumhuriyet\'in ilanı: 29 Ekim 1923',
          ],
        ),
        StudySection(
          heading: 'Kurtuluş Savaşı ve Cumhuriyet',
          body: 'I. Dünya Savaşı sonrası Osmanlı işgal altına girdi. '
              'Mustafa Kemal Atatürk 19 Mayıs 1919\'da Samsun\'a çıkarak Kurtuluş Savaşı\'nı başlattı. '
              '1923\'te Lozan Antlaşması ile bağımsızlık tanındı ve Türkiye Cumhuriyeti ilan edildi. '
              'Atatürk inkılapları ile harf, takvim, ölçü ve hukuk sistemi yenilendi.',
          keyPoints: [
            '19 Mayıs 1919: Samsun\'a çıkış — kurtuluş mücadelesinin başlangıcı',
            '23 Nisan 1920: TBMM\'nin açılışı',
            '30 Ağustos 1922: Büyük Taarruz zaferi',
            '24 Temmuz 1923: Lozan Antlaşması',
            '29 Ekim 1923: Cumhuriyetin ilanı',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Dünya Tarihi',
      emoji: '🌐',
      sections: [
        StudySection(
          heading: 'Antik Uygarlıklar',
          body: 'Antik Mısır\'da firavunlar yönetici ve tanrı olarak kabul edildi. '
              'Piramitler firavunların mezarlarıdır; en büyüğü Keops Piramidi\'dir. '
              'Antik Yunan demokrasinin beşiğidir; Atina ilk demokratik şehir devleti sayılır. '
              'Roma İmparatorluğu hukuk, mimari ve yönetim anlayışıyla Batı uygarlığını derinden etkiledi.',
          keyPoints: [
            'Antik Mısır: piramitler, firavunlar, hiyeroglif yazısı',
            'Antik Yunan: demokrasi, felsefe (Sokrates, Platon, Aristo)',
            'Roma: hukuk sistemi, yollar, cumhuriyet ve imparatorluk',
            'Çin: Büyük Duvar, kâğıt ve barut icadı',
            'Hint: Budizm ve Hinduizm\'in doğduğu topraklar',
          ],
        ),
        StudySection(
          heading: 'Orta Çağ ve Yeniçağ',
          body: 'Orta Çağ\'da Avrupa\'da derebeylik sistemi hüküm sürdü. '
              'İslam uygarlığı bilim, matematik ve tıpta öncü oldu. '
              'Yeniçağ\'a geçişte matbaanın icadı (Gutenberg, 1450) ve coğrafi keşifler belirleyici oldu. '
              'Amerika\'nın keşfi (1492, Kristof Kolomb) dünya dengelerini değiştirdi.',
          keyPoints: [
            'Derebeylik: toprak sahiplerinin köylüler üzerindeki hakimiyeti',
            'Haçlı Seferleri: Hristiyan Avrupa\'nın Kudüs\'ü alma girişimleri',
            'Matbaa: Gutenberg, 1450 — bilginin yayılmasını hızlandırdı',
            'Coğrafi Keşifler: Kolomb (1492), Vasco da Gama, Magellan',
            'Reform: Avrupa\'da Hristiyanlıkta dönüşüm hareketi',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Osmanlı Devleti',
      emoji: '🕌',
      sections: [
        StudySection(
          heading: 'Kuruluş ve Yükselme',
          body: 'Osmanlı Devleti 1299 yılında Osman Bey tarafından kuruldu. '
              'Fatih Sultan Mehmet 1453\'te İstanbul\'u fethederek Bizans\'ı sona erdirdi. '
              'Kanuni Sultan Süleyman döneminde devlet en geniş sınırlarına ulaştı.',
          keyPoints: [
            '1299: Osmanlı Devleti\'nin kuruluşu (Osman Bey)',
            '1453: İstanbul\'un fethi — Fatih Sultan Mehmet',
            'Kanuni dönemi: Osmanlı\'nın en parlak çağı',
            'Devşirme sistemi: yeniçeri ocağı için asker yetiştirilmesi',
            'Divan-ı Hümayun: padişahın başkanlık ettiği devlet meclisi',
          ],
        ),
        StudySection(
          heading: 'Gerileme ve Dağılma',
          body: 'Sanayi Devrimi\'nin gerisinde kalan Osmanlı, 19. yüzyılda toprak kaybetmeye başladı. '
              '1. Dünya Savaşı\'nda yenilgiye uğrayan Osmanlı, '
              'Mondros Mütarekesi (1918) ve Sevr Antlaşması (1920) ile dağılma sürecine girdi.',
          keyPoints: [
            'Tanzimat Fermanı (1839): modernleşme girişimi',
            'Meşrutiyet: padişahın yetkilerini sınırlayan anayasal dönem',
            '1. Dünya Savaşı (1914-1918): Osmanlı İttifak Devletleri\'nde',
            'Mondros Mütarekesi (1918): Osmanlı\'nın savaştan çekilmesi',
            'Sevr Antlaşması (1920): imzalanmadı, kurtuluş savaşıyla reddedildi',
          ],
        ),
      ],
    ),
    StudyTopic(
      title: 'Atatürk\'ün İnkılapları',
      emoji: '🇹🇷',
      sections: [
        StudySection(
          heading: 'Siyasi İnkılaplar',
          body: 'Cumhuriyetin ilanı (29 Ekim 1923) ile Türkiye Cumhuriyeti kuruldu. '
              'Halifeliğin kaldırılması (1924) din-devlet işlerini ayırdı. '
              'Saltanatın kaldırılması (1922) ile monarşiye son verildi.',
          keyPoints: [
            '1922: Saltanatın kaldırılması',
            '29 Ekim 1923: Cumhuriyetin ilanı',
            '1924: Halifeliğin kaldırılması',
            '1924 Anayasası: ilk cumhuriyet anayasası',
            '1930: Belediye seçimlerinde kadınlara oy hakkı',
          ],
        ),
        StudySection(
          heading: 'Kültürel ve Toplumsal İnkılaplar',
          body: 'Harf Devrimi (1928) ile Arap alfabesinden Latin alfabesine geçildi. '
              'Soyadı kanunu (1934) ile Mustafa Kemal Atatürk soyadını aldı. '
              'Eğitim birleştirildi; medreseler kapatılıp modern okullar açıldı.',
          keyPoints: [
            '1928: Harf Devrimi — Arap harflerinden Latine geçiş',
            '1931: Türk Tarih Kurumu kuruldu',
            '1932: Türk Dil Kurumu kuruldu',
            '1934: Soyadı Kanunu',
            'Tevhid-i Tedrisat: öğretimi birleştirme kanunu (1924)',
          ],
        ),
      ],
    ),
  ];

  /// AI soru üretiminde kullanılmak üzere: [StudyContent.content] ile aynı ders başlıkları.
  static String quizSyllabusLine(String categoryId) {
    if (categoryId == 'fen') {
      return 'Bu kategori ortaokul Fen Bilimleri (fizik, kimya, biyoloji) müfredatını kapsar. '
          'Ortaokul düzeyinde sorular üret; üç disiplin arasında dengeli dağılım yap (yaklaşık üçte bir fizik, üçte bir kimya, üçte bir biyoloji). '
          'Her soru tek bir disipline odaklansın.';
    }
    final topics = content[categoryId];
    if (topics == null || topics.isEmpty) return '';
    final names = topics.map((t) => t.title).join('; ');
    return 'Bu kategori konu başlıkları (soruları bunlar arasında dengeli üret): $names.';
  }
}
