import SwiftUI
import UIKit

// MARK: - DynamicHeightTextField

struct DynamicHeightTextField: UIViewRepresentable {

    // MARK: - Internal Properties

    @Binding var text: String
    @Binding var height: CGFloat

    // MARK: - Internal Methods

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.text = text
        textView.font(.medium(15))
        textView.backgroundColor = .clear
        textView.textContainerInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        textView.autocorrectionType = .no
        textView.textAlignment = .left
        textView.delegate = context.coordinator
        textView.layoutManager.delegate = context.coordinator
        context.coordinator.textView = textView
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {

        // MARK: - Internal Properties

        var dynamicHeightTextField: DynamicHeightTextField
        weak var textView: UITextView?

        // MARK: - Lifecycle

        init(_ dynamicSizeTextField: DynamicHeightTextField) {
            self.dynamicHeightTextField = dynamicSizeTextField
        }

        // MARK: - Internal Methods

        func textViewDidChange(_ textView: UITextView) {
            dynamicHeightTextField.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }

        func layoutManager(
            _ layoutManager: NSLayoutManager,
            didCompleteLayoutFor textContainer: NSTextContainer?,
            atEnd layoutFinishedFlag: Bool
        ) {
            DispatchQueue.main.async { [weak self] in
                guard let textView = self?.textView else { return }
                let size = textView.sizeThatFits(textView.bounds.size)
                if self?.dynamicHeightTextField.height != size.height {
                    self?.dynamicHeightTextField.height = size.height
                }
            }
        }
    }
}
