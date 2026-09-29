import Foundation
import AVFoundation
import Combine

/// Kaydedilmiş tarla notlarını oynatan basit oynatıcı.
@MainActor
final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false

    private var player: AVAudioPlayer?

    /// Verilen dosyayı çalar; aynı dosya çalıyorsa duraklatır.
    func toggle(fileName: String) {
        if isPlaying {
            stop()
            return
        }
        let url = AudioRecorder.documentsURL(for: fileName)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            let p = try AVAudioPlayer(contentsOf: url)
            p.delegate = self
            p.play()
            player = p
            isPlaying = true
        } catch {
            print("Oynatma hatası: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.isPlaying = false
            self.player = nil
        }
    }
}
