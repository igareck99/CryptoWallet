import SwiftUI

struct CodeVerificationView<ViewModel: VerificationPresenterProtocol>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                Text(viewModel.resources.typeCode)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 22))
                    .foregroundColor(viewModel.colors.titleColor.wrappedValue)
                    .padding(.horizontal, 24)

                Text(viewModel.resources.codeSentOn + " " + viewModel.phoneNumber)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15))
                    .foregroundColor(viewModel.colors.subtitleColor.wrappedValue)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                OtpView(
                    colors: viewModel.colors,
                    focusedField: .init(),
                    verificationCode: viewModel.verificationCode,
                    numberOfInputs: viewModel.numberOfInputs,
                    hyphenOpacity: viewModel.hyphenOpacity,
                    strokeColor: viewModel.strokeColor,
                    getPin: viewModel.getPin,
                    limitText: viewModel.limitText
                )
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 26)
                    .padding(.top, 50)

                Text(viewModel.resources.wrongOTP)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 32)
                    .padding(.top, 1)
                    .opacity(viewModel.errorTextOpacity.wrappedValue)
                    .foregroundColor(viewModel.colors.errorTextColor.wrappedValue)

                Text(viewModel.resources.resendText + " (\(viewModel.seconds) " + viewModel.resources.seconds + ")")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15))
                    .foregroundColor(viewModel.colors.resendTextColor.wrappedValue)
                    .padding(.horizontal, 47)
                    .padding(.top, 80)
                    .onTapGesture {
                        viewModel.onTapResend()
                    }
            }
            .padding(.top, 24)
            .clipped()
        }
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
}