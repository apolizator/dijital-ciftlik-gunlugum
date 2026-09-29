import SwiftUI

/// Bir tarlanın o anki güncel durumu. Dashboard'daki kart renklerini ve rozetleri belirler.
enum FieldStatus: String, Codable, CaseIterable, Identifiable {
    case bos          // Boş / nadasta
    case surulu       // Sürüldü
    case ekili        // Ekili
    case sulandi      // Sulandı (bakım durumu)
    case ilaclandi    // İlaçlandı (bakım durumu)
    case hasatEdildi  // Hasat edildi

    var id: String { rawValue }

    /// Kartta ve rozetlerde gösterilecek Türkçe etiket.
    var label: String {
        switch self {
        case .bos:         return "Boş"
        case .surulu:      return "Sürüldü"
        case .ekili:       return "Ekili"
        case .sulandi:     return "Sulandı"
        case .ilaclandi:   return "İlaçlandı"
        case .hasatEdildi: return "Hasat Edildi"
        }
    }

    /// Karta hâkim olacak renk.
    var color: Color {
        switch self {
        case .bos:         return Color(.systemGray)
        case .surulu:      return Color.brown
        case .ekili:       return Color.green
        case .sulandi:     return Color.blue
        case .ilaclandi:   return Color.purple
        case .hasatEdildi: return Color.orange
        }
    }

    /// Rozet/başlık ikonu.
    var systemImage: String {
        switch self {
        case .bos:         return "circle.dashed"
        case .surulu:      return "square.grid.3x3.fill"
        case .ekili:       return "leaf.fill"
        case .sulandi:     return "drop.fill"
        case .ilaclandi:   return "cross.vial.fill"
        case .hasatEdildi: return "basket.fill"
        }
    }
}
