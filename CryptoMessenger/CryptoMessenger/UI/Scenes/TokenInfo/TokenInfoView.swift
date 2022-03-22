import SwiftUI

// MARK: - TokenInfoView

struct TokenInfoView: View {

    // MARK: - Internal Properties

    @Binding var showTokenInfo: Bool
    @StateObject var viewModel: TokenInfoViewModel

    // MARK: - Body

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.tokenInfoTitle())
                        .font(.bold(15))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        R.image.buyCellsMenu.close.image
                            .onTapGesture {
                                showTokenInfo = false
                            }
                    }
                }
            }
    }

    private var content: some View {
        VStack {
            Divider()
                .padding(.top, 16)
            Spacer()
        }
    }
}
