import SwiftUI

struct WarningView<ViewModel: WarningViewProtocol>: View {

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {

                    Text(viewModel.resources.generatePhraseWarning)
                        .font(.title2Regular22)
                        .padding(.top, 47)

                    Text(viewModel.resources.generatePhraseWarningDescription)
                        .font(.subheadlineRegular15)
                        .foregroundColor(viewModel.resources.textColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 295)
                        .padding(.top, 12)

                    viewModel.resources.person
                        .padding(.top, 32)
                        .frame(alignment: .center)
                        .scaledToFill()
                        .padding(.horizontal, 2)

                    proceedButton
                        .padding(.top, 60)

                    cancelButton
                        .padding(.top, 21)
                        .padding(.bottom, 48)
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
    }

    private var proceedButton: some View {
        Button {
            viewModel.onProceedTap()
        } label: {
            switch viewModel.animateProceedButton {
            case false:
            Text("Продолжить")
                .frame(width: 237)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.buttonBackground)
                .padding()
            case true:
            ProgressView()
                .tint(viewModel.resources.background)
                .frame(width: 12, height: 12)
            }
        }
    }

    private var cancelButton: some View {
        Button {
            viewModel.onCancelTap()
        } label: {
            Text("Отмена")
                .foregroundColor(viewModel.resources.background)
                .frame(width: 237)
                .font(.bodySemibold17)
                .padding()
        }
        .frame(width: 237, height: 48)
        .background(viewModel.resources.buttonBackground)
        .cornerRadius(8)
    }

    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(viewModel.resources.backButtonImage)
                    .font(.bodyRegular17)
                    .foregroundColor(viewModel.resources.titleColor)
            }
        }
    }
}
