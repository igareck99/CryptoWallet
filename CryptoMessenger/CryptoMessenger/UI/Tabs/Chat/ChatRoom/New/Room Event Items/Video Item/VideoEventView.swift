import SwiftUI

struct VideoEventView<
    Placeholder: View,
    EventData: View,
    LoadData: View
>: View {

    @StateObject var viewModel = VideoEventViewModel()

    var model: VideoEvent {
        didSet {
            viewModel.update(url: model.videoUrl)
        }
    }

    let loadData: LoadData
    let placeholder: Placeholder
    let eventData: EventData
    
    var body: some View {
        ZStack {
            viewModel.thumbnailImage
                .frame(width: 208, height: 250)
                .onTapGesture {
                    model.onTap()
                }
                .overlay(alignment: .bottomTrailing) {
                    eventData
                }
                .overlay(alignment: .topLeading) {
                    loadData.opacity(.zero)
                }
            Image(systemName: "arrow.down.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.osloGrayApprox)
                .background(Circle().fill(Color.white)).opacity(.zero)
        }
        .frame(width: 208, height: 250)
        .onTapGesture {
            model.onTap()
        }
        .onAppear {
            viewModel.update(url: model.videoUrl)
        }
    }
}
