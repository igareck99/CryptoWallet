import LinkPresentation
import SwiftUI

// MARK: - LinkRow(UIViewRepresentable)

struct LinkRow: UIViewRepresentable {

    // MARK: - Internal properties

    var previewURL: URL
    @Binding var redraw: Bool

    // MARK: - Internal Methods

    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(url: previewURL)
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: previewURL) { metadata, error in
            if let data = metadata {
                DispatchQueue.main.async {
                    view.metadata = data
                    view.sizeToFit()
                    self.redraw.toggle()
                }
            } else if error != nil {
                let data = LPLinkMetadata()
                data.title = "Custom title"
                view.metadata = data
                view.sizeToFit()
                self.redraw.toggle()
            }
        }
        return view
    }

    func updateUIView(_ view: LPLinkView, context: Context) {
    }
}
