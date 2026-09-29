import SwiftUI

/// Zaman tünelinde tek bir işlemi gösteren satır.
/// Sol tarafta dikey çizgi ve renkli nokta ile kronoloji hissi verir.
struct TimelineRowView: View {
    let activity: FieldActivity
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Zaman çizgisi göstergesi.
            VStack(spacing: 0) {
                Rectangle()
                    .fill(isFirst ? Color.clear : Color(.systemGray4))
                    .frame(width: 2, height: 10)
                Image(systemName: activity.type.systemImage)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(activity.type.color)
                    .clipShape(Circle())
                Rectangle()
                    .fill(isLast ? Color.clear : Color(.systemGray4))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(activity.type.label)
                    .font(.subheadline.weight(.semibold))
                Text(AppFormat.timeline.string(from: activity.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if !activity.detail.isEmpty {
                    Text(activity.detail)
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .padding(.top, 2)
                }
            }
            .padding(.bottom, 16)

            Spacer(minLength: 0)
        }
    }
}
