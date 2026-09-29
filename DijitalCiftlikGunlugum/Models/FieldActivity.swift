import Foundation
import SwiftData

/// Tarlada yapılan tek bir tarımsal işlem (Sürüm, Ekim, İlaçlama vb.).
/// Zaman tünelindeki her satır bir FieldActivity'dir.
@Model
final class FieldActivity {
    var typeRaw: String
    var date: Date
    var detail: String   // Opsiyonel serbest not (örn. "Buğday ekildi, 20 kg/dönüm")

    var field: Field?

    init(type: ActivityType, date: Date = .now, detail: String = "") {
        self.typeRaw = type.rawValue
        self.date = date
        self.detail = detail
    }

    var type: ActivityType {
        get { ActivityType(rawValue: typeRaw) ?? .surum }
        set { typeRaw = newValue.rawValue }
    }
}
