import SwiftUI
import SwiftData

/// Yeni tarla ekleme formu.
struct AddFieldView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var areaText = ""
    @State private var cropName = ""
    @State private var status: FieldStatus = .bos

    private var area: Double? {
        Double(areaText.replacingOccurrences(of: ",", with: "."))
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && (area ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Tarla Bilgileri") {
                    TextField("Tarla adı (örn. Dere Tarlası)", text: $name)
                    HStack {
                        TextField("Büyüklük", text: $areaText)
                            .keyboardType(.decimalPad)
                        Text("dönüm").foregroundStyle(.secondary)
                    }
                    TextField("Ekili ürün (opsiyonel)", text: $cropName)
                }

                Section("Başlangıç Durumu") {
                    Picker("Durum", selection: $status) {
                        ForEach(FieldStatus.allCases) { s in
                            Label(s.label, systemImage: s.systemImage).tag(s)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Yeni Tarla")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: save).disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        guard let area else { return }
        let field = Field(
            name: name.trimmingCharacters(in: .whitespaces),
            area: area,
            cropName: cropName.trimmingCharacters(in: .whitespaces),
            status: status
        )
        context.insert(field)
        dismiss()
    }
}
