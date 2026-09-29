import SwiftUI
import SwiftData

/// "Bugün Ne Yaptım?" modülü — klavyeyle uğraşmadan hazır şablonlarla
/// hızlı işlem girişi. Seçilen işlem tarlanın durumunu otomatik günceller.
struct AddActivityView: View {
    @Bindable var field: Field
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: ActivityType?
    @State private var date: Date = .now
    @State private var detail: String = ""

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Bugün bu tarlada ne yaptın?")
                        .font(.headline)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(ActivityType.allCases) { type in
                            templateButton(type)
                        }
                    }

                    if selectedType != nil {
                        detailsSection
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("İşlem Gir")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: save)
                        .disabled(selectedType == nil)
                }
            }
        }
    }

    private func templateButton(_ type: ActivityType) -> some View {
        let isSelected = selectedType == type
        return Button {
            withAnimation(.snappy) { selectedType = type }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: type.systemImage)
                    .font(.title2)
                Text(type.label)
                    .font(.subheadline.weight(.medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 84)
            .background(isSelected ? type.color.opacity(0.18) : Color(.secondarySystemGroupedBackground))
            .foregroundStyle(isSelected ? type.color : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(isSelected ? type.color : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            DatePicker("Tarih", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .environment(\.locale, Locale(identifier: "tr_TR"))

            VStack(alignment: .leading, spacing: 6) {
                Text("Not (opsiyonel)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("Örn. Buğday, 22 kg/dönüm", text: $detail, axis: .vertical)
                    .lineLimit(2...4)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            if let type = selectedType {
                Label(
                    "Bu işlem tarlayı '\(type.resultingStatus.label)' durumuna geçirecek.",
                    systemImage: "info.circle"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    private func save() {
        guard let type = selectedType else { return }
        let activity = FieldActivity(type: type, date: date,
                                     detail: detail.trimmingCharacters(in: .whitespacesAndNewlines))
        activity.field = field
        field.activities.append(activity)
        context.insert(activity)

        // Tarlanın durumunu otomatik güncelle.
        field.applyStatusChange(to: type.resultingStatus, at: date)

        dismiss()
    }
}
