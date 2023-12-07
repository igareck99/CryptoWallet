import SwiftUI

struct ZeroView: View {
    let model: ZeroViewModel
    var body: some View {
        EmptyView()
            .frame(width: .zero, height: .zero)
    }
}
