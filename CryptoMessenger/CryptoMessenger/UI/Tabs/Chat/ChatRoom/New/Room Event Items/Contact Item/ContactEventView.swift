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
            HStack(spacing: 8) {
                avatar

                VStack(alignment: .leading, spacing: 4) {
                    Text(model.title)
                        .font(.system(size: 16))
                        .foregroundColor(.chineseBlack)
                    Text(model.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.dodgerBlue)
                }
                Spacer()
            }

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

            HStack {
                reactions
                Spacer()
            }
            eventData
        }
        .frame(width: 238)
        .fixedSize(horizontal: true, vertical: false)
    }
}
