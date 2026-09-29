import SwiftUI

/// Dashboard'da tek bir tarlayı temsil eden kart.
/// Sol kenar şeridi ve rozet, tarlanın anlık durumunu renkle gösterir.
struct FieldCardView: View {
    let field: Field

    var body: some View {
        HStack(spacing: 0) {
            // Durumu renkle vurgulayan sol şerit.
            Rectangle()
                .fill(field.status.color)
                .frame(width: 6)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(field.name)
                            .font(.headline)
                        Text("\(AppFormat.area(field.area)) dönüm"
                             + (field.cropName.isEmpty ? "" : " • \(field.cropName)"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    statusBadge
                }

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(daysText)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
            .padding(14)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(field.status.color.opacity(0.25), lineWidth: 1)
        )
    }

    private var statusBadge: some View {
        Label(field.status.label, systemImage: field.status.systemImage)
            .font(.caption.bold())
            .labelStyle(.titleAndIcon)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(field.status.color.opacity(0.15))
            .foregroundStyle(field.status.color)
            .clipShape(Capsule())
    }

    private var daysText: String {
        let days = field.daysInCurrentStatus
        switch days {
        case 0:  return "Bugün güncellendi"
        case 1:  return "1 gündür \(field.status.label.lowercased())"
        default: return "\(days) gündür \(field.status.label.lowercased())"
        }
    }
}
