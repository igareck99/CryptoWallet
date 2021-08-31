import SwiftUI
import UIKit

// MARK: - ScalableButtonView

struct ScalableButtonView: View {
    private let title: String
    private let isDisabled: Bool
    private var didTap: (() -> Void)?

    init(title: String, isDisabled: Bool = false, didTap: (() -> Void)?) {
        self.title = title
        self.isDisabled = isDisabled
        self.didTap = didTap
    }

    var body: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                didTap?()
            }
        } label: {
            Text(title)
                .font(.system(size: 22, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 76, idealHeight: 76, alignment: .center)
                .background(isDisabled ? Color(#colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)) : Color(#colorLiteral(red: 0.8, green: 0.4823529412, blue: 0.8941176471, alpha: 1)))
                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .cornerRadius(16)
                .shadow(color: Color(#colorLiteral(red: 0.04705882353, green: 0.07843137255, blue: 0.1294117647, alpha: 0.1401914321)), radius: 31, x: 0, y: 13)
        }
        .disabled(isDisabled)
        .buttonStyle(ScaleButtonStyle())
    }

    private struct ScaleButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 1.07 : 1.0)
                .animation(.easeInOut(duration: 0.3))
        }
    }
}
