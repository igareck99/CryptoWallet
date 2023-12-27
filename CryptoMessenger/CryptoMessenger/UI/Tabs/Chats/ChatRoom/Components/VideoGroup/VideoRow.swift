import SwiftUI

struct VideoRow: View {

    @StateObject var viewModel: VideoViewModel

    init(viewModel: VideoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            viewModel.thumbnailImage?
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
    }
}
