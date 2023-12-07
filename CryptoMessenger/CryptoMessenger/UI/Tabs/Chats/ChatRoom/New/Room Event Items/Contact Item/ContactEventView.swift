import SwiftUI

// MARK: - ContactEventView

struct ContactEventView<
    EventData: View,
    Reactions: View,
    Avatar: View
>: View {
    let model: ContactItem
    let eventData: EventData
    let reactions: Reactions
    let avatar: Avatar

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 8) {
                avatar
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .font(.bodyRegular17)
                        .foregroundColor(.chineseBlack)
                    Text(model.subtitle)
                        .font(.footnoteRegular13)
                        .foregroundColor(.dodgerBlue)
                }
                .frame(height: 39)
                Spacer()
            }
            if !model.mxId.isEmpty {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.dodgerBlue, lineWidth: 2.0)
                    .frame(height: 44.0)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
                    .overlay {
                        Text("Профиль AURA")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.dodgerBlue)
                            .frame(maxWidth: .infinity)
                    }
                    .onTapGesture {
                        model.onTap()
                    }
            }
            HStack {
                reactions
                Spacer()
            }
            eventData
        }
        .frame(minWidth: 238, idealWidth: 238, maxWidth: 238, minHeight: 82, maxHeight: 202)
        .fixedSize(horizontal: true, vertical: false)
    }
}
