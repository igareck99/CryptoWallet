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
        VStack(spacing: .zero) {
            HStack(alignment: .center, spacing: 8) {
                avatar
                VStack(alignment: .leading, spacing: .zero) {
                    Text(model.title)
                        .font(.calloutRegular16)
                        .foregroundColor(.chineseBlack)
                    Text(model.subtitle)
                        .font(.footnoteRegular13)
                        .foregroundColor(.dodgerBlue)
                }
                .frame(height: 38)
                .padding(.top, 5)
                Spacer()
            }
            .frame(height: 48)
            if !model.mxId.isEmpty {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.dodgerBlue, lineWidth: 2.0)
                    .frame(height: 44.0)
                    .frame(width: 215, height: 44)
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
            if !model.hasReactions {
                eventData
            } else {
                VStack(spacing: .zero) {
                    HStack {
                        reactions
                        Spacer()
                    }
                    .padding(.top, 10)
                    eventData
                }
            }
        }
        .frame(minWidth: 212, idealWidth: 212, maxWidth: 212)
        .fixedSize(horizontal: true, vertical: false)
    }
}
