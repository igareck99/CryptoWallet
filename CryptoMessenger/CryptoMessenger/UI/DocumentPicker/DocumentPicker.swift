import SwiftUI
import UIKit
import UniformTypeIdentifiers

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func documentPicker(
        onCancel: VoidBlock? = nil,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) -> some View {
        modifier(
            DocumentPickerView(onCancel: onCancel, onDocumentsPicked: onDocumentsPicked)
        )
    }
}

// MARK: - DocumentPickerView

struct DocumentPickerView: ViewModifier {

    // MARK: - Internal Properties

    var onCancel: VoidBlock?
    var onDocumentsPicked: GenericBlock<[URL]>

    // MARK: - Life Cycle

    init(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        self.onCancel = onCancel
        self.onDocumentsPicked = onDocumentsPicked
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        DocumentPicker(onCancel: onCancel, onDocumentsPicked: onDocumentsPicked)
    }
}

// MARK: - DocumentPicker

struct DocumentPicker: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    var onCancel: VoidBlock?
    var onDocumentsPicked: GenericBlock<[URL]>
    @StateObject var viewModel = DocumentsViewerViewModel()

    // MARK: - Life Cycle

    init(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        self.onCancel = onCancel
        self.onDocumentsPicked = onDocumentsPicked
    }

    // MARK: - Internal Methods

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
            var type: UTType = .content
            if viewModel.isAnyFileAvailable {
                type = UTType.item
            }
            let pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [type], asCopy: true)
            pickerController.allowsMultipleSelection = false
            pickerController.delegate = context.coordinator
            return pickerController
        }

    func updateUIViewController(
        _ uiViewController: UIDocumentPickerViewController,
        context: UIViewControllerRepresentableContext<DocumentPicker>
    ) {}

    func makeCoordinator() -> Coordinator { .init(self) }

    // MARK: - Coordinator

    final class Coordinator: NSObject {

        // MARK: - Internal Properties

        private(set) var parent: DocumentPicker
        private(set) var presented = false

        // MARK: - Life Cycle

        init(_ parent: DocumentPicker) {
            self.parent = parent
            super.init()
        }
    }
}

// MARK: - Coordinator (UIDocumentPickerDelegate)

extension DocumentPicker.Coordinator: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        parent.onDocumentsPicked(urls)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        parent.onCancel?()
    }
}