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
        ZStack {
            AsyncImage(
                defaultUrl: model.imageUrl,
                placeholder: {
                    placeholder
                        .frame(width: 245, height: 152)
                        .cornerRadius(16)
                },
                resultView: {
                    Image(uiImage: $0)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 245, height: 152)
                        .cornerRadius(16)
                }
            )
            .overlay(alignment: .bottomTrailing) {
                eventData.padding([.trailing, .bottom], 8)
            }
            .overlay(alignment: .topLeading) {
                // TODO: Нужно реализовать логику загрузки по тапу
                // пока грузится автоматом
                loadData.opacity(.zero)
            }
            // TODO: Нужно реализовать логику загрузки по тапу
            // пока грузится автоматом
            Image(systemName: "arrow.down.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.osloGrayApprox)
                .background(Circle().fill(Color.white))
                .opacity(.zero)
        }
    }
}
