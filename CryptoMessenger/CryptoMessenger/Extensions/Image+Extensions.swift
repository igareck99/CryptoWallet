import SwiftUI

extension Image {
    func update(color: Color) -> some View {
        self.renderingMode(.template)
            .foregroundColor(color)
    }
}
