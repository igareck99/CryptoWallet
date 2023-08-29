import SwiftUI

struct ImageEventView<
    Placeholder: View,
    EventData: View
>: View {
    let model: ImageEvent
    let placeholder: Placeholder
    let eventData: EventData

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(
                defaultUrl: model.imageUrl,
                placeholder: {
                    placeholder
                        .frame(width: 224, height: 245)
                        .cornerRadius(16)
                },
                resultView: {
                    Image(uiImage: $0)
                        .resizable()
                        .frame(width: 224, height: 245)
                        .cornerRadius(16)
                }
            )
            .frame(width: 224, height: 245)
            .onTapGesture {
                model.onTap()
            }
            eventData
        }
        .frame(width: 224, height: 245)
    }
}
// arrow.down.circle.fill
