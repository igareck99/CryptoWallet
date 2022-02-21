import SwiftUI
import PDFKit

// MARK: - PDFKitView

struct PDFKitView: View {

    // MARK: - Internal Properties

    let url: URL

    // MARK: - Body

    var body: some View {
        PDFKitRepresentedView(url)
    }
}

// MARK: - PDFKitRepresentedView (UIViewRepresentable)

struct PDFKitRepresentedView: UIViewRepresentable {

    // MARK: - Internal Properties

    let url: URL

    // MARK: - Life Cycle

    init(_ url: URL) {
        self.url = url
    }

    // MARK: - Internal Methods

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {}
}
