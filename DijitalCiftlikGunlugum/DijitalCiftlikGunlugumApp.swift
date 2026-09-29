import SwiftUI
import SwiftData

@main
struct DijitalCiftlikGunlugumApp: App {
    /// Tüm modelleri kapsayan SwiftData konteyneri.
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: Field.self, FieldActivity.self, FieldNote.self
            )
        } catch {
            fatalError("ModelContainer oluşturulamadı: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .modelContainer(container)
    }
}
