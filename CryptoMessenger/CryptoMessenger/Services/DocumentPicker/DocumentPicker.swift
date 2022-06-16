import SwiftUI
import UIKit

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func documentPicker(
        isPresented: Binding<Bool> = .constant(false),
        onCancel: VoidBlock? = nil,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) -> some View {
        modifier(
            DocumentPickerView(isPresented: isPresented, onCancel: onCancel, onDocumentsPicked: onDocumentsPicked)
        )
    }
}

// MARK: - DocumentPickerView

struct DocumentPickerView: ViewModifier {

    // MARK: - Internal Properties

    @Binding var isPresented: Bool
    var onCancel: VoidBlock?
    var onDocumentsPicked: GenericBlock<[URL]>

    // MARK: - Life Cycle

    init(
        isPresented: Binding<Bool>,
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        self._isPresented = isPresented
        self.onCancel = onCancel
        self.onDocumentsPicked = onDocumentsPicked
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        DocumentPicker(isPresented: $isPresented, onCancel: onCancel, onDocumentsPicked: onDocumentsPicked)
    }
}

// MARK: - DocumentPicker

struct DocumentPicker: UIViewControllerRepresentable {

    // MARK: - Internal Properties

    @Binding var isPresented: Bool
    var onCancel: VoidBlock?
    var onDocumentsPicked: GenericBlock<[URL]>

    // MARK: - Life Cycle

    init(
        isPresented: Binding<Bool> = .constant(false),
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) {
        self._isPresented = isPresented
        self.onCancel = onCancel
        self.onDocumentsPicked = onDocumentsPicked
    }

    // MARK: - Internal Methods

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
            let pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [.content], asCopy: true)
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
        parent.isPresented.toggle()
        parent.onDocumentsPicked(urls)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        parent.isPresented.toggle()
        parent.onCancel?()
    }
}
