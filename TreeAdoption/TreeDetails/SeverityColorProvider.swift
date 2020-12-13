import SwiftUI

class SeverityColorProvider {
    static func severityColor(_ severityFraction: Double) -> Color {
        if (0 ... 0.25).contains(severityFraction) {
            return .progressGreen
        }

        if (0.25 ... 0.5).contains(severityFraction) {
            return .progressYellow
        }

        if (0.51 ... 0.75).contains(severityFraction) {
            return .progressOrange
        }

        if (0.75 ... 1).contains(severityFraction) {
            return .progressRed
        }

        return .progressRed
    }
}
