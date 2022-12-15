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
        VStack(spacing: 0) {
            ForEach(viewModel.actions, id: \.id) { act in
                Button(action: {
                    vibrate()
                    switch act {
                    case .notifications:
                        viewModel.updateNotifications()
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
                        .background(act.color.suColor.opacity(0.1))
                        .cornerRadius(20)
                        Text(act.title)
                            .font(.regular(17))
                            .foreground(act == .delete || act == .blockUser || act == .clearHistory ? .red() : .blue())
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
