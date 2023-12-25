import SwiftUI

// MARK: - ResizeableTextView(UIViewRepresentable)

struct ResizeableTextView: UIViewRepresentable {

    // MARK: - Internal Properties

	@Binding var text: String
	@Binding var height: CGFloat
    @Binding var cornerRadius: CGFloat
	@State var editing = false
    @State var fieldBackgroundColor = UIColor.aliceBlue
	var placeholderText: String

    // MARK: - Internal Methods

	func makeUIView(context: Context) -> UITextView {
		let textView = UITextView()
		textView.isEditable = true
		textView.isScrollEnabled = true
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 16
		textView.text = placeholderText
		textView.delegate = context.coordinator
		textView.textColor = .chineseBlack
		textView.font = UIFont.systemFont(ofSize: 17)
		return textView
	}

    func updateUIView(_ textView: UITextView, context: Context) {
        if self.text.isEmpty {
            DispatchQueue.main.async {
                textView.text = self.editing ? "" : self.placeholderText
                textView.textColor = self.editing ? .chineseBlack : .romanSilver
            }
		}
        DispatchQueue.main.async {
            if self.height != textView.contentSize.height {
                self.height = textView.contentSize.height > 38 ? textView.contentSize.height : 34
            }
            textView.backgroundColor = fieldBackgroundColor
            textView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 0)
        }
	}

	func makeCoordinator() -> Coordinator {
		ResizeableTextView.Coordinator(self)
	}

    // MARK: - Coordinator

	class Coordinator: NSObject, UITextViewDelegate {

        // MARK: - Internal Properties

		var parent: ResizeableTextView

        // MARK: - Lifecycle

		init(_ params: ResizeableTextView) {
			self.parent = params
		}

        // MARK: - Internal Methods

		func textViewDidBeginEditing(_ textView: UITextView) {
			DispatchQueue.main.async {
				self.parent.editing = true
			}
		}

		func textViewDidEndEditing(_ textView: UITextView) {
			DispatchQueue.main.async {
				self.parent.editing = false
			}
		}

		func textViewDidChange(_ textView: UITextView) {
			DispatchQueue.main.async {
				self.parent.height = textView.contentSize.height
				self.parent.text = textView.text
			}
		}
	}
}
