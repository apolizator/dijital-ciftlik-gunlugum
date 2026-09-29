import Foundation
import AVFoundation
import Combine

/// Tarla notları için basit ses kaydedici.
/// Kayıtlar Documents dizinine .m4a olarak yazılır; FieldNote yalnızca dosya adını saklar.
@MainActor
final class AudioRecorder: ObservableObject {
    @Published var isRecording = false
    @Published var elapsed: Double = 0

    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    private(set) var currentFileName: String?

    /// Documents dizini — ses dosyalarının kalıcı konumu.
    static func documentsURL(for fileName: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    /// Mikrofon izni ister. Info.plist'te NSMicrophoneUsageDescription gereklidir.
    func requestPermission() async -> Bool {
        await withCheckedContinuation { cont in
            AVAudioApplication.requestRecordPermission { granted in
                cont.resume(returning: granted)
            }
        }
    }

    func start() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let fileName = "kayit-\(UUID().uuidString).m4a"
            let url = Self.documentsURL(for: fileName)
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let rec = try AVAudioRecorder(url: url, settings: settings)
            rec.record()

            recorder = rec
            currentFileName = fileName
            elapsed = 0
            isRecording = true

            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    guard let self, let r = self.recorder else { return }
                    self.elapsed = r.currentTime
                }
            }
        } catch {
            print("Kayıt başlatılamadı: \(error)")
        }
    }

    /// Kaydı durdurur ve (dosyaAdı, süre) döndürür.
    @discardableResult
    func stop() -> (fileName: String, duration: Double)? {
        guard let recorder, let fileName = currentFileName else { return nil }
        let duration = recorder.currentTime
        recorder.stop()
        timer?.invalidate()
        timer = nil
        isRecording = false
        self.recorder = nil
        try? AVAudioSession.sharedInstance().setActive(false)
        return (fileName, duration)
    }

    /// Kaydedilmeyen geçici dosyayı siler.
    func discard() {
        if let fileName = currentFileName {
            try? FileManager.default.removeItem(at: Self.documentsURL(for: fileName))
        }
        recorder?.stop()
        recorder = nil
        timer?.invalidate()
        timer = nil
        isRecording = false
        currentFileName = nil
    }
}
