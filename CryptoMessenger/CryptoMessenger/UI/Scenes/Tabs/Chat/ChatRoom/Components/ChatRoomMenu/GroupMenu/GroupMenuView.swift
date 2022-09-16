import SwiftUI

// MARK: - GroupMenuView

struct GroupMenuView: View {

    // MARK: - Internal Properties

    @Binding var action: GroupAction?
    @Binding var cardGroupPosition: CardPosition
    @StateObject var viewModel = GroupChatMenuViewModel()

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.actions, id: \.id) { act in
                Button(action: {
                    vibrate()
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
                            .foreground(act == .delete || act == .blacklist ? .red() : .blue())
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
