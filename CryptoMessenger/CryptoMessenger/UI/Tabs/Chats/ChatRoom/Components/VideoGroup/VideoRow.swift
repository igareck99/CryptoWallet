import SwiftUI
import AVFoundation

struct VideoRow: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: VideoViewModel

    // MARK: - Private Properties

    @State private var thumbnailImage = Image("")

    // MARK: - Lifecycle

    init(viewModel: VideoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            thumbnailImage
                .resizable()
                .scaledToFill()
                .frame(width: 202, height: 245)
                .background(Color.chineseBlack)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 4.0,
                        style: .continuous))
                .shadow(radius: 4.0)
        }
        .padding(.vertical)
        .onAppear {
            viewModel.thumbnailUrl?.getThumbnailImage(completion: { image in
                guard let image = image else { return }
                self.thumbnailImage = image
            })
        }
    }
}
