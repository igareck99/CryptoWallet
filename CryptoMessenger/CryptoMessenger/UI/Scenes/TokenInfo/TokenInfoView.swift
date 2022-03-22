import SwiftUI

// MARK: - TokenInfoView

struct TokenInfoView: View {

    // MARK: - Internal Properties

    @Binding var showTokenInfo: Bool
    @StateObject var viewModel: TokenInfoViewModel

    // MARK: - Body

    var body: some View {
        content
    }

    // MARK: - Private Properties

    private var headerView: some View {
        HStack {
            R.image.buyCellsMenu.close.image
                .onTapGesture {
                    showTokenInfo = false
                }
            Spacer()
            Text(R.string.localizable.tokenInfoTitle())
                .font(.bold(15))
            Spacer()
        }
    }

    private var content: some View {
        VStack {
            headerView
                .padding(.top, 16)
                .padding(.horizontal, 16)
            Divider()
                .padding(.top, 16)
            Spacer()
        }
    }
}
