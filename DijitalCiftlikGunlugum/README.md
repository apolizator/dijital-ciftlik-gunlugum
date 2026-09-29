# Dijital Çiftlik Günlüğüm 🌾

Birden fazla tarlası olan çiftçinin tarlalarını, anlık durumlarını ve geçmiş
tüm faaliyetlerini tek bir iPhone ekranından takip etmesini sağlayan native iOS
uygulaması.

SwiftUI + SwiftData ile yazıldı. iOS 17 ve üzeri hedeflenir.

## Özellikler

- **Tek Ekran Dashboard** — Tüm tarlalar renkli kartlar olarak listelenir. Kartın
  sol şeridi ve rozeti tarlanın anlık durumunu (Sürüldü, Ekili, Hasat Edildi…) ve
  kaç gündür o durumda olduğunu gösterir.
- **"Bugün Ne Yaptım?" Girişi** — Sürüm, Ekim, İlaçlama, Gübreleme, Sulama, Biçim,
  Hasat şablonlarıyla klavyeye dokunmadan hızlı işlem girişi. Her giriş tarlanın
  durumunu otomatik günceller.
- **Zaman Tüneli** — Her tarlanın detayında, geçmiş işlemler kronolojik bir
  aktivite günlüğü olarak görünür.
- **Sesli + Fotoğraflı + Yazılı Notlar** — Tarlada gezerken hızlıca ses kaydı al,
  fotoğraf çek/seç veya yazılı not ekle; hepsi o günün tarihine işlenir.

## Mimari

Veriler cihazda SwiftData ile kalıcı olarak saklanır (internet gerektirmez).

| Model | Sorumluluk |
|-------|-----------|
| `Field` | Tarla: ad, dönüm, ürün, anlık durum, durum değişim tarihi |
| `FieldActivity` | Tek bir tarımsal işlem (zaman tüneli satırı) |
| `FieldNote` | Yazı + fotoğraf + ses içeren serbest not |

Durum mantığı: Her `ActivityType`, yapıldığında tarlayı belirli bir `FieldStatus`'a
geçirir (örn. Ekim → Ekili). Durum gerçekten değiştiğinde "kaç gündür" sayacı
sıfırlanır.

## Dosya Yapısı

```
DijitalCiftlikGunlugum/
├── DijitalCiftlikGunlugumApp.swift   # Uygulama girişi + ModelContainer
├── Models/
│   ├── FieldStatus.swift             # Durum enum'u (renk, ikon, etiket)
│   ├── ActivityType.swift            # İşlem türü + sonuç durumu
│   ├── Field.swift                   # Tarla modeli
│   ├── FieldActivity.swift           # İşlem modeli
│   └── FieldNote.swift               # Not modeli
├── Services/
│   ├── AudioRecorder.swift           # Ses kaydı
│   └── AudioPlayer.swift             # Ses oynatma
├── Support/
│   ├── Formatters.swift              # Tarih/sayı biçimlendirme (tr_TR)
│   └── PreviewData.swift             # Önizleme için örnek veri
└── Views/
    ├── DashboardView.swift           # Ana ekran (kart listesi)
    ├── FieldCardView.swift           # Tarla kartı
    ├── FieldDetailView.swift         # Detay + zaman tüneli + notlar
    ├── TimelineRowView.swift         # Zaman tüneli satırı
    ├── NoteRowView.swift             # Not kartı
    ├── AddFieldView.swift            # Tarla ekleme
    ├── AddActivityView.swift         # "Bugün Ne Yaptım?" işlem girişi
    ├── AddNoteView.swift             # Not ekleme (ses/foto/yazı)
    └── CameraPicker.swift            # Kamera sarmalayıcı
```

## Xcode'da Çalıştırma

1. **Xcode 15+** ile yeni bir proje oluştur: *File → New → Project → iOS → App*.
   - Product Name: `DijitalCiftlikGunlugum`
   - Interface: **SwiftUI**, Language: **Swift**, Storage: **None**
     (SwiftData'yı kodda kendimiz kuruyoruz).
   - Minimum Deployments: **iOS 17.0**.
2. Xcode'un oluşturduğu varsayılan `ContentView.swift` ve `...App.swift`
   dosyalarını **sil**.
3. Bu klasördeki tüm `.swift` dosyalarını Xcode projesine sürükle-bırak ile ekle
   ("Copy items if needed" işaretli olsun). Klasör yapısını gruplar halinde
   korumak için klasörleri olduğu gibi sürükleyebilirsin.
4. **Info.plist izinleri** ekle (Target → Info → Custom iOS Target Properties):
   - `NSMicrophoneUsageDescription` — "Tarla notlarına ses kaydı eklemek için
     mikrofon kullanılır."
   - `NSCameraUsageDescription` — "Tarla fotoğrafı çekmek için kamera kullanılır."
   - `NSPhotoLibraryUsageDescription` — "Galeriden fotoğraf eklemek için kullanılır."
5. **Cmd+R** ile çalıştır.

> Not: Kamera ve mikrofon yalnızca gerçek cihazda tam çalışır. Simülatörde
> galeriden fotoğraf seçme ve tüm diğer özellikler çalışır.

### Alternatif: XcodeGen ile otomatik kurulum

Bilgisayarında [XcodeGen](https://github.com/yonyz/XcodeGen) varsa, bu klasördeki
`project.yml` ile `.xcodeproj`'u tek komutla üretebilirsin:

```bash
cd DijitalCiftlikGunlugum
xcodegen generate
open DijitalCiftlikGunlugum.xcodeproj
```

İzin açıklamaları ve iOS 17 hedefi `project.yml` içinde hazır tanımlıdır.

## Sonraki adımlar (öneriler)

- Hava durumu rozeti / yağış geçmişi
- Tarla bazlı maliyet ve verim takibi
- iCloud (CloudKit) ile cihazlar arası senkron
- Bildirimler ("X tarlası 30 gündür ekili — ilaçlama zamanı?")
