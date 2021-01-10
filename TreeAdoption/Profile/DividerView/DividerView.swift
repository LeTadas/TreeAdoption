import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .fill(Color.backgroundGray)
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding(.leading, 12)
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView()
    }
}
