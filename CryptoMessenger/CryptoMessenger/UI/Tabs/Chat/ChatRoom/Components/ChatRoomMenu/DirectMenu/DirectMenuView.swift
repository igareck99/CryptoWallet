import SwiftUI

// MARK: - DirectMenuView

struct DirectMenuView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: DirectChatMenuViewModel
    @Binding var action: DirectAction?
    @Binding var cardGroupPosition: CardPosition
    @State private var actions: [DirectAction] = []
    var onMedia: VoidBlock?

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        content
    }

    var content: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.actions, id: \.id) { act in
                Button(action: {
                    vibrate()
                    switch act {
                    case .notifications:
                        viewModel.showNotificationsChangeView = true
                        return
                    case .notificationsOff:
                        viewModel.updateNotifications()
                        return
                    case .media:
                        onMedia?()
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
                            .foregroundColor(act == .delete || act == .blockUser || act == .clearHistory ? .spanishCrimson : .dodgerBlue)
                            .padding(.leading, 16)
                        Spacer()
                    }
                    .frame(height: 64)
                    .padding([.leading, .trailing], 16)
                })
                .frame(height: 64)
            }
            Spacer()
        }
    }
}
