import Foundation

/// Uygulama genelinde paylaşılan tarih/sayı biçimlendiricileri.
enum AppFormat {
    /// "23 Haziran 2026" gibi.
    static let longDate: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "tr_TR")
        f.dateFormat = "d MMMM yyyy"
        return f
    }()

    /// "23 Haz, 14:30" gibi — zaman tüneli satırları için.
    static let timeline: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "tr_TR")
        f.dateFormat = "d MMM, HH:mm"
        return f
    }()

    /// Dönüm değerini sade gösterir (ör. 12 ya da 12,5).
    static func area(_ value: Double) -> String {
        let nf = NumberFormatter()
        nf.locale = Locale(identifier: "tr_TR")
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf.string(from: value as NSNumber) ?? "\(value)"
    }

    /// Saniyeyi mm:ss biçimine çevirir.
    static func duration(_ seconds: Double) -> String {
        let total = Int(seconds.rounded())
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}
