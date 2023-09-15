import SwiftUI

struct ImageEventView<
    Placeholder: View,
    EventData: View,
    LoadData: View
>: View {
    let loadData: LoadData
    let placeholder: Placeholder
    let eventData: EventData
    var model: ImageEvent {
        didSet {
            viewModel.update(url: model.imageUrl)
        }
    }

    @StateObject var viewModel = ImageEventViewModel()

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                AsyncImage(
                    defaultUrl: model.imageUrl,
                    placeholder: {
                        placeholder
                            .frame(width: 224, height: 284)
                            .cornerRadius(16)
                    },
                    resultView: {
                        Image(uiImage: $0)
                            .resizable()
                            .frame(width: 224, height: 284)
                            .cornerRadius(16)
                    }
                )
                .frame(width: 224, height: 284)
                .onTapGesture {
                    model.onTap()
                }
                .overlay(alignment: .bottomTrailing) {
                    eventData
                }
                .overlay(alignment: .topLeading) {
                    loadData
                }
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.osloGrayApprox)
                    .background(Circle().fill(Color.white))
            }
            .frame(width: 224, height: 284)
        }
    }
}
