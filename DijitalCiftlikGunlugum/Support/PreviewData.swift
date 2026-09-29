import Foundation
import SwiftData

/// SwiftUI önizlemeleri için bellek içi örnek veri üretir.
enum PreviewData {
    @MainActor
    static let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Field.self, FieldActivity.self, FieldNote.self,
            configurations: config
        )
        let ctx = container.mainContext

        let cal = Calendar.current
        func daysAgo(_ d: Int) -> Date {
            cal.date(byAdding: .day, value: -d, to: .now) ?? .now
        }

        let dere = Field(name: "Dere Tarlası", area: 24, cropName: "Buğday", status: .ekili)
        dere.statusChangedAt = daysAgo(12)
        dere.activities = [
            FieldActivity(type: .surum, date: daysAgo(20), detail: "Derin sürüm yapıldı"),
            FieldActivity(type: .ekim, date: daysAgo(12), detail: "Buğday, 22 kg/dönüm"),
            FieldActivity(type: .gubreleme, date: daysAgo(5), detail: "Taban gübresi")
        ]

        let yol = Field(name: "Yol Kenarı", area: 8.5, cropName: "Arpa", status: .surulu)
        yol.statusChangedAt = daysAgo(3)
        yol.activities = [
            FieldActivity(type: .surum, date: daysAgo(3), detail: "")
        ]

        let bayir = Field(name: "Bayır Tarla", area: 15, cropName: "", status: .hasatEdildi)
        bayir.statusChangedAt = daysAgo(40)

        ctx.insert(dere)
        ctx.insert(yol)
        ctx.insert(bayir)
        return container
    }()

    /// Detay ekranı önizlemesi için örnek bir tarla.
    @MainActor
    static var sampleField: Field {
        let ctx = container.mainContext
        let descriptor = FetchDescriptor<Field>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? ctx.fetch(descriptor))?.first
            ?? Field(name: "Örnek Tarla", area: 10, status: .ekili)
    }
}
