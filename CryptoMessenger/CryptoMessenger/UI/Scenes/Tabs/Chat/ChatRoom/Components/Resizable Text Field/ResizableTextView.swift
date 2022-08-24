import SwiftUI

struct ResizeableTextView: UIViewRepresentable {

	@Binding var text: String
	@Binding var height: CGFloat
	@State var editing = false
	var placeholderText: String

	func makeUIView(context: Context) -> UITextView {
		let textView = UITextView()
		textView.isEditable = true
		textView.isScrollEnabled = true
		textView.text = placeholderText
		textView.delegate = context.coordinator
		textView.textColor = .black
		textView.font = UIFont.systemFont(ofSize: 20)
		return textView
	}

	func updateUIView(_ textView: UITextView, context: Context) {
		if self.text.isEmpty == true {
			textView.text = self.editing ? "" : self.placeholderText
			textView.textColor = self.editing ? .black : .lightGray
		}

		DispatchQueue.main.async {
			self.height = textView.contentSize.height
			textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
		}
	}

	func makeCoordinator() -> Coordinator {
		ResizeableTextView.Coordinator(self)
	}

	class Coordinator: NSObject, UITextViewDelegate {
		var parent: ResizeableTextView

		init(_ params: ResizeableTextView) {
			self.parent = params
		}

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
