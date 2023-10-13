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
                    .font(.title2Regular22)
                Text(data.value.description)
                    .multilineTextAlignment(.center)
                    .font(.subheadlineRegular15)
                    .foreground(.romanSilver)
            }
            Spacer()
        }
    }
}
