import SwiftUI
import UIKit

// MARK: - ScalableButtonView

struct ScalableButtonView: View {

    // MARK: - Internal Properties

    private let title: String
    private let isDisabled: Bool
    private var didTap: (() -> Void)?

    // MARK: - Lifecycle

    init(title: String, isDisabled: Bool = false, didTap: (() -> Void)?) {
        self.title = title
        self.isDisabled = isDisabled
        self.didTap = didTap
    }

    // MARK: - Body

    var body: some View {
        Button {
            delay(0.2) { didTap?() }
        } label: {
            Text(title)
                .font(.callout2Semibold16)
                .frame(maxWidth: .infinity, minHeight: 44, idealHeight: 44, alignment: .center)
                //.background(isDisabled ? .lightGray() : .blue())
                .foreground(isDisabled ? .romanSilver : .dodgerBlue)
                .cornerRadius(8)
        }
        .disabled(isDisabled)
        .buttonStyle(ScaleButtonStyle())
    }

    // MARK: - ScaleButtonStyle

    private struct ScaleButtonStyle: ButtonStyle {

        // MARK: - Internal Methods

        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 1.07 : 1.0)
                .animation(.easeInOut(duration: 0.3))
        }
    }
}
