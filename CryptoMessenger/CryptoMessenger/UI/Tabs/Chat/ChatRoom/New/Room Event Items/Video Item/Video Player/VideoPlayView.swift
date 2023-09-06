import AVKit
import SwiftUI

struct VideoPlayView: View {

    @StateObject var viewModel: VideoPlayerViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            VideoPlayer(player: viewModel.player)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onDisappear {
                    viewModel.onDisappear()
                }
                .onAppear {
                    viewModel.onAppear()
                }
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    makeToolBar()
                }
        }
    }

    @ToolbarContentBuilder
    private func makeToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
        }
    }
}
