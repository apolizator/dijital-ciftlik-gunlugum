import Foundation
import SwiftData

/// Tarla — uygulamanın merkezindeki varlık.
/// Birden fazla tarla, dashboard'da birer kart olarak listelenir.
@Model
final class Field {
    var name: String
    var area: Double            // Dönüm
    var cropName: String        // Ekili ürün (opsiyonel, boş olabilir)
    var createdAt: Date

    /// Tarlanın şu anki durumu. Her işlem girişinde otomatik güncellenir.
    var statusRaw: String
    /// Mevcut duruma en son ne zaman geçildi — "kaç gündür bu durumda" hesabı için.
    var statusChangedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \FieldActivity.field)
    var activities: [FieldActivity] = []

    @Relationship(deleteRule: .cascade, inverse: \FieldNote.field)
    var notes: [FieldNote] = []

    init(
        name: String,
        area: Double,
        cropName: String = "",
        status: FieldStatus = .bos,
        createdAt: Date = .now
    ) {
        self.name = name
        self.area = area
        self.cropName = cropName
        self.createdAt = createdAt
        self.statusRaw = status.rawValue
        self.statusChangedAt = createdAt
    }

    /// statusRaw üzerinden tip güvenli erişim.
    var status: FieldStatus {
        get { FieldStatus(rawValue: statusRaw) ?? .bos }
        set { statusRaw = newValue.rawValue }
    }

    /// Tarlanın kaç tam gündür mevcut durumda olduğunu döndürür.
    var daysInCurrentStatus: Int {
        let days = Calendar.current.dateComponents(
            [.day], from: statusChangedAt, to: .now
        ).day ?? 0
        return max(0, days)
    }

    /// Tarihe göre yeniden eskiye sıralı aktiviteler (zaman tüneli için).
    var sortedActivities: [FieldActivity] {
        activities.sorted { $0.date > $1.date }
    }

    /// Tarihe göre yeniden eskiye sıralı notlar.
    var sortedNotes: [FieldNote] {
        notes.sorted { $0.date > $1.date }
    }

    /// Bir işlem uygulandığında durumu ve durum değişim tarihini günceller.
    func applyStatusChange(to newStatus: FieldStatus, at date: Date) {
        // Yalnızca durum gerçekten değiştiyse "kaç gündür" sayacını sıfırla.
        if newStatus != status {
            statusChangedAt = date
        }
        status = newStatus
    }
}
