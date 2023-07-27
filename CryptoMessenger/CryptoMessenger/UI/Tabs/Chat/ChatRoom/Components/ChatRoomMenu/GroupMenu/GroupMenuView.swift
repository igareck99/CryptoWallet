import SwiftUI

// MARK: - GroupMenuView

struct GroupMenuView: View {

    // MARK: - Internal Properties

    @Binding var action: GroupAction?
    @Binding var cardGroupPosition: CardPosition
    @StateObject var viewModel: GroupChatMenuViewModel

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.actions, id: \.id) { act in
                Button(action: {
                    vibrate()
                    switch act {
                    case .notifications:
                        viewModel.showNotificationsChangeView = true
                        return
                    default:
                        break
                    }
                    action = act
                    cardGroupPosition = .bottom
                }, label: {
                    HStack {
                        HStack {
                            act.image
                        }
                        .frame(width: 40, height: 40)
                        .background(Color.chineseShadow)
                        .cornerRadius(20)
                        Text(act.title)
                            .font(.system(size: 17, weight: .regular))
                            .foreground(act == .delete || act == .blacklist ? .spanishCrimson : .dodgerBlue)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    .frame(height: 64)
                    .padding([.leading, .trailing], 16)
                })
                .frame(height: 64)
            }
        }
    }
}
