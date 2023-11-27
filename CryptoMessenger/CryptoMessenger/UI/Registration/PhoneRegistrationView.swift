import SwiftUI

// MARK: - 

struct PhoneRegistrationView<ViewModel: RegistrationPresenterProtocol>: View {

    @StateObject var viewModel: ViewModel
    @FocusState private var keyboardFoucsed: Bool
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                Text(viewModel.sources.typeYourPhone)
                    .multilineTextAlignment(.center)
                    .font(.title2Regular22)
                    .foregroundColor(viewModel.colors.titleColor.wrappedValue)
                    .padding(.horizontal, 24)

                Text(viewModel.sources.registrationInfo)
                    .multilineTextAlignment(.center)
                    .font(.subheadlineRegular15)
                    .foregroundColor(viewModel.colors.subtitleColor.wrappedValue)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                SelectCountryView(
                    selectCountry: viewModel.selectedCountry,
                    colors: viewModel.colors
                ) {
                    viewModel.didTapSelectCountry()
                }
                .padding(.horizontal, 16)
                .padding(.top, 48)

                InputPhoneView(
                    phonePlaceholder: viewModel.sources.yourNumber,
                    countryCode: viewModel.countryCode,
                    phone: viewModel.phone,
                    isPhoneNumberValid: viewModel.isPhoneNumberValid,
                    keyboardFoucsed: $keyboardFoucsed,
                    onCountryPhoneUpdate: viewModel.onCountryPhoneUpdate,
                    colors: viewModel.colors
                )
                .padding(.horizontal, 16)
                .padding(.top, 24)

                Text(viewModel.sources.inavlidCountryCode)
                    .font(.caption1Regular12)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 1)
                    .opacity(viewModel.errorTextOpacity.wrappedValue)
                    .foregroundColor(viewModel.colors.selectCountryErrorColor.wrappedValue)
            }
            .safeAreaInset(edge: .bottom) {
                sendCodeButton
                    .padding(.bottom)
            }
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture {
                keyboardFoucsed = false
            }
            .padding(.top, 24)
            .clipped()
        }
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: viewModel.messageText,
                color: .spanishCrimson
            )
        }
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
    }

    private var sendCodeButton: some View {
        Button {
            viewModel.didTapNextButton()
        } label: {
            ZStack {
                ProgressView()
                    .tint(viewModel.colors.buttonLoaderColor.wrappedValue)
                    .opacity(viewModel.buttonLoaderOpacity.wrappedValue)
                Text(viewModel.sources.sendCode)
                    .font(.bodySemibold17)
                    .foregroundColor(viewModel.colors.buttonTextColor.wrappedValue)
                    .opacity(viewModel.buttonTextOpacity.wrappedValue)
            }
        }
        .disabled(!viewModel.sendButtonEnabled.wrappedValue)
        .frame(width: 237, height: 48)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(viewModel.colors.sendButtonColor.wrappedValue)
        )
    }
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                R.image.navigation.backButton.image
            }
        }
    }
}
