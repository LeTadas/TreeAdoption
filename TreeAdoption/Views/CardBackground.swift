import SwiftUI

struct CardBackground: View {
    let withShadow: Bool

    init(withShadow: Bool = false) {
        self.withShadow = withShadow
    }

    var body: some View {
        Rectangle()
            .fill(Color.white)
            .cornerRadius(10)
            .shadow(
                color: withShadow ? Color.black.opacity(0.1) : Color.clear,
                radius: 5
            )
    }
}
