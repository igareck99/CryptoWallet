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
        VStack(alignment: .center) {
            Spacer()
            VStack(spacing: 4) {
                data.value.image
                Text(data.value.title)
                    .font(.system(size: 22, weight: .regular))
                Text(data.value.description)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15, weight: .regular))
                    .foreground(.romanSilver)
            }
            Spacer()
        }
    }
}
