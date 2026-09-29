import SwiftUI

/// "Bugün Ne Yaptım?" modülünde seçilen tarımsal işlem türü.
/// Her işlem, gerçekleştirildiğinde tarlanın durumunu otomatik olarak günceller.
enum ActivityType: String, Codable, CaseIterable, Identifiable {
    case surum      // Sürüm
    case ekim       // Ekim
    case ilaclama   // İlaçlama
    case gubreleme  // Gübreleme
    case sulama     // Sulama
    case bicim      // Biçim
    case hasat      // Hasat

    var id: String { rawValue }

    var label: String {
        switch self {
        case .surum:     return "Sürüm"
        case .ekim:      return "Ekim"
        case .ilaclama:  return "İlaçlama"
        case .gubreleme: return "Gübreleme"
        case .sulama:    return "Sulama"
        case .bicim:     return "Biçim"
        case .hasat:     return "Hasat"
        }
    }

    var systemImage: String {
        switch self {
        case .surum:     return "square.grid.3x3.fill"
        case .ekim:      return "leaf.fill"
        case .ilaclama:  return "cross.vial.fill"
        case .gubreleme: return "aqi.medium"
        case .sulama:    return "drop.fill"
        case .bicim:     return "scissors"
        case .hasat:     return "basket.fill"
        }
    }

    var color: Color {
        switch self {
        case .surum:     return .brown
        case .ekim:      return .green
        case .ilaclama:  return .purple
        case .gubreleme: return .teal
        case .sulama:    return .blue
        case .bicim:     return .pink
        case .hasat:     return .orange
        }
    }

    /// Bu işlem yapıldığında tarlanın geçeceği yeni durum.
    /// İlaçlama/gübreleme gibi bakım işlemleri ana ekim durumunu bozmaz
    /// ancak son işlemi rozet olarak yansıtır.
    var resultingStatus: FieldStatus {
        switch self {
        case .surum:     return .surulu
        case .ekim:      return .ekili
        case .ilaclama:  return .ilaclandi
        case .gubreleme: return .ilaclandi
        case .sulama:    return .sulandi
        case .bicim:     return .hasatEdildi
        case .hasat:     return .hasatEdildi
        }
    }
}
