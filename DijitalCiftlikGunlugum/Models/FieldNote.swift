import Foundation
import SwiftData

/// Tarlaya iliştirilen serbest not: yazılı metin, fotoğraf ve/veya ses kaydı.
/// Üç tür de aynı kayıtta opsiyonel olarak bulunabilir.
@Model
final class FieldNote {
    var date: Date
    var text: String

    /// Çekilen fotoğrafın ham verisi (JPEG). SwiftData dış depolamada saklar.
    @Attribute(.externalStorage)
    var photoData: Data?

    /// Ses kaydının dosya adı (Documents dizininde saklanır).
    var audioFileName: String?
    /// Ses kaydının saniye cinsinden süresi.
    var audioDuration: Double

    var field: Field?

    init(
        date: Date = .now,
        text: String = "",
        photoData: Data? = nil,
        audioFileName: String? = nil,
        audioDuration: Double = 0
    ) {
        self.date = date
        self.text = text
        self.photoData = photoData
        self.audioFileName = audioFileName
        self.audioDuration = audioDuration
    }

    var hasPhoto: Bool { photoData != nil }
    var hasAudio: Bool { audioFileName != nil }
    var hasText: Bool { !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}
