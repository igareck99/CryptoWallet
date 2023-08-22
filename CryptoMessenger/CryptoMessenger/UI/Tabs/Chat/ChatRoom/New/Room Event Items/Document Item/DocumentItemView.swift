import SwiftUI

struct DocumentItemView<
    EventData: View,
    Reactions: View
>: View {
    let model: DocumentItem
    let eventData: EventData
    let reactions: Reactions

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: 8) {
                Image(systemName: model.imageName)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.dodgerBlue)

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .font(.system(size: 16))
                        .foregroundColor(.chineseBlack)
                    Text(model.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.manatee)
                }
            }
            .frame(maxWidth: .infinity)

            reactions

            eventData
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}
