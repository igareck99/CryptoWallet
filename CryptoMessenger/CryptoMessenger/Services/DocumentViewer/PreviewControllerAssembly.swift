import SwiftUI

enum PreviewControllerAssembly {
    static func build(
        url: URL,
        fileName: String
    ) -> some View {
        let viewModel = DocumentViewerViewModel(
            url: url,
            isUploadFinished: .constant(false),
            fileName: fileName
        )
        let view = PreviewControllerView(viewModel: viewModel)
        return view
    }
}
