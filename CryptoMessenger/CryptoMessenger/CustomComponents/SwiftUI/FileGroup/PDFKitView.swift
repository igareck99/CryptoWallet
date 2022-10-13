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
    var viewModel: PDFKitViewModel

    // MARK: - Life Cycle

    init(_ url: URL) {
        self.url = url
        self.viewModel = PDFKitViewModel(url: url)
    }

    // MARK: - Internal Methods

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: viewModel.data)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        viewModel.downloadPdf { data in
            guard let data = data else { return }
            viewModel.data = data
        }
    }
}
