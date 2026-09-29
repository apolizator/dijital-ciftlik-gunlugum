import SwiftUI
import SwiftData
import PhotosUI
import UIKit

/// Tarlaya sesli, fotoğraflı ve/veya yazılı not ekleme ekranı.
struct AddNoteView: View {
    @Bindable var field: Field
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var recorder = AudioRecorder()

    @State private var text = ""
    @State private var photoData: Data?
    @State private var pickerItem: PhotosPickerItem?
    @State private var showingCamera = false

    // Tamamlanmış kaydın bilgisi.
    @State private var recordedFileName: String?
    @State private var recordedDuration: Double = 0

    private var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || photoData != nil
            || recordedFileName != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    audioSection
                    photoSection
                    textSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Yeni Not")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") {
                        recorder.discard()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: save).disabled(!canSave)
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraPicker { image in
                    photoData = image.jpegData(compressionQuality: 0.8)
                }
                .ignoresSafeArea()
            }
            .onChange(of: pickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }

    // MARK: - Ses

    private var audioSection: some View {
        sectionCard(title: "Ses Kaydı", icon: "waveform") {
            if let _ = recordedFileName {
                HStack {
                    Label(AppFormat.duration(recordedDuration), systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Spacer()
                    Button("Sil", role: .destructive) {
                        recorder.discard()
                        recordedFileName = nil
                        recordedDuration = 0
                    }
                }
            } else if recorder.isRecording {
                HStack {
                    Image(systemName: "record.circle")
                        .foregroundStyle(.red)
                        .symbolEffect(.pulse)
                    Text(AppFormat.duration(recorder.elapsed))
                        .monospacedDigit()
                    Spacer()
                    Button {
                        if let result = recorder.stop() {
                            recordedFileName = result.fileName
                            recordedDuration = result.duration
                        }
                    } label: {
                        Label("Durdur", systemImage: "stop.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            } else {
                Button {
                    Task {
                        if await recorder.requestPermission() {
                            recorder.start()
                        }
                    }
                } label: {
                    Label("Kaydı Başlat", systemImage: "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Fotoğraf

    private var photoSection: some View {
        sectionCard(title: "Fotoğraf", icon: "camera") {
            if let photoData, let uiImage = UIImage(data: photoData) {
                VStack(spacing: 10) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    Button("Fotoğrafı Kaldır", role: .destructive) {
                        self.photoData = nil
                        self.pickerItem = nil
                    }
                }
            } else {
                HStack(spacing: 12) {
                    Button {
                        showingCamera = true
                    } label: {
                        Label("Çek", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("Galeriden Seç", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    // MARK: - Yazı

    private var textSection: some View {
        sectionCard(title: "Yazılı Not", icon: "text.alignleft") {
            TextField("Bir şeyler yaz...", text: $text, axis: .vertical)
                .lineLimit(3...8)
        }
    }

    private func sectionCard<Content: View>(
        title: String, icon: String, @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func save() {
        let note = FieldNote(
            date: .now,
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            photoData: photoData,
            audioFileName: recordedFileName,
            audioDuration: recordedDuration
        )
        note.field = field
        field.notes.append(note)
        context.insert(note)
        dismiss()
    }
}
