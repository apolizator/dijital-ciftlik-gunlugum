import SwiftUI
import UIKit

/// Bir tarla notunu (yazı + fotoğraf + ses) gösteren kart.
struct NoteRowView: View {
    let note: FieldNote
    @StateObject private var player = AudioPlayer()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(AppFormat.timeline.string(from: note.date))
                .font(.caption)
                .foregroundStyle(.secondary)

            if let data = note.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if note.hasText {
                Text(note.text)
                    .font(.body)
            }

            if note.hasAudio {
                audioPlayerBar
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var audioPlayerBar: some View {
        Button {
            if let name = note.audioFileName {
                player.toggle(fileName: name)
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)
                Text("Ses kaydı")
                    .font(.subheadline)
                Spacer()
                Text(AppFormat.duration(note.audioDuration))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .background(Color.blue.opacity(0.12))
            .foregroundStyle(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
