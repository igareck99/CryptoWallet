import SwiftUI

// MARK: - SecurityView

struct SecurityView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: SecurityViewModel

    // MARK: - Private Properties

    @State private var activateBiometry = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
        .background(viewModel.resources.innactiveBackground)
        .onAppear {
            viewModel.send(.onAppear)
        }
        .alert(
            isPresented: $viewModel.showBiometryErrorAlert,
            content: {
                Alert(
                    title: Text(viewModel.resources.securityBiometryEror),
                    message: nil,
                    dismissButton: .default(Text("OK"))
                )
            }
        )
    }

    private var content: some View {
        List {
            Section {
                securitySection
            } header: {
                Text(viewModel.resources.securityTitle)
            }
            if viewModel.isPrivacyAvailable {
                Section {
                    privacySection
                } header: {
                    Text(viewModel.resources.securityPrivacy)
                        .foregroundColor(viewModel.resources.textColor)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.ghostWhite.edgesIgnoringSafeArea(.all))
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
    }

    private var securitySection: some View {
        VStack(spacing: 0) {
            Toggle(viewModel.resources.securityPinCodeTitle,
                   isOn: $viewModel.isPinCodeOn)
            .background(.white)
            .frame(height: 34)
            .listRowSeparator(.hidden)
            .onAppear {
                if viewModel.isPinCodeUpdate() {
                    viewModel.dataIsUpdated = true
                }
            }
            .onChange(of: viewModel.isPinCodeOn) { value in
                viewModel.pinCodeAvailabilityDidChange(value: value)
            }
            if viewModel.isPinCodeOn {
                Divider()
                    .frame(height: 0.5)
                    .foreground(.gainsboro)
                SecurityAdvancedCellView(title: viewModel.resources.securityBiometryEnterTitle,
                                         description: viewModel.resources.securityBiometryEnterState,
                                         currentState: $viewModel.isBiometryOn)
                .frame(height: 34)
                .onChange(of: viewModel.isBiometryOn) { item in
                    if item {
                        viewModel.send(.biometryActivate)
                    } else {
                        viewModel.updateIsBiometryOn(item: false)
                    }
                }
                if viewModel.isFalsePinCodeOnAvailable {
                    SecurityAdvancedCellView(
                        title: viewModel.resources.securityFalsePasswordTitle,
                        description: viewModel.resources.securityFalsePasswordState,
                        currentState: $viewModel.isFalsePinCodeOn
                    )
                    .frame(height: 34)
                    .onChange(of: viewModel.isFalsePinCodeOn) { item in
                        if item {
                            viewModel.send(.onFalsePassword)
                        } else {
                            viewModel.updateIsFalsePinCode(item: false)
                        }
                    }
                }
            }
        }
    }

    private var privacySection: some View {
        ForEach(SecurityCellItem.allCases, id: \.self) { type in
            switch type {
            case .seedPhrase:
                PrivacyCellView(
                    item: type,
                    phraseStatus: viewModel.isPhraseExist()
                )
                .background(viewModel.resources.background)
                .listRowSeparator(.hidden,
                                  edges: .bottom)
                .frame(height: 51)
                .onTapGesture {
                    viewModel.send(.onPhrase)
                }
//            case .session:
//                PrivacyCellView(item: type)
//                .background(viewModel.resources.background)
//                .frame(height: 37)
//                .listRowSeparator(.visible,
//                                  edges: .top)
//                .onTapGesture {
//                    viewModel.send(.onSession)
//                }
//            case .blockList:
//                PrivacyCellView(item: type)
//                .background(viewModel.resources.background)
//                .frame(height: 24)
//                .onTapGesture {
//                    viewModel.send(.onBlockList)
//                }
            default:
                EmptyView()
            }
        }
    }

    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.securityTitle)
            .font(.bodySemibold17)
            .foregroundColor(.chineseBlack)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                R.image.navigation.backButton.image
            }
        }
    }
}
