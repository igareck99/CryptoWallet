import SwiftUI

// MARK: - EmptyInfoViewModel

struct EmptyInfoViewModel: Identifiable, ViewGeneratable {

    var id = UUID()
    let value: ChatHistoryEmpty

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        EmptyInfoViewModelView(data: self).anyView()
    }
}

// MARK: - EmptyInfoViewModelView

struct EmptyInfoViewModelView: View {

    let data: EmptyInfoViewModel

    // MARK: - Body

    var body: some View {
        Group {
            Spacer()
            VStack {
                data.value.image
                Text(data.value.title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 22, weight: .regular))
                    .padding(.top, 4)
                Text(data.value.description)
                    .font(.system(size: 15, weight: .regular))
                    .foreground(.romanSilver)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                if data.value == .noChats {
                    sendButton
                        .padding(.top, 80)
                }
            }
            Spacer()
        }
    }
    
    private var sendButton: some View {
        Button {
        } label: {
            Text("Пригласить друзей")
                .font(.system(size: 17, weight: .semibold))
                .foreground(.white)
                .padding()
                .frame(width: 237, height: 48)
                .background(
                    Rectangle()
                        .fill(Color.dodgerBlue)
                        .cornerRadius(8)
                )
        }
        .frame(maxWidth: .infinity, idealHeight: 48)
    }
}
