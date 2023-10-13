import SwiftUI

// MARK: - SecurityView

struct SecurityView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: SecurityViewModel
    @StateObject var generateViewModel = GeneratePhraseViewModel()
    @State private var showAddWallet = false

    // MARK: - Private Properties

    @State private var activateBiometry = false

    // MARK: - Body

    var body: some View {
        content
        .background(viewModel.resources.innactiveBackground)
        .navigationBarHidden(false)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.send(.onAppear)
        }
		.alert(isPresented: $viewModel.showBiometryErrorAlert, content: {
            Alert(title: Text(viewModel.resources.securityBiometryEror), message: nil,
                  dismissButton: .default(Text("OK")))
        })
        .sheet(isPresented: $showAddWallet, content: {
            GeneratePhraseView(
                viewModel: generateViewModel,
                onSelect: { type in
                    switch type {
                    case .importKey:
                        viewModel.send(.onImportKey)
                        showAddWallet = false
                    default:
                        break
                    }
                },
                onCreate: { })
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.resources.securityTitle)
                    .font(.bodySemibold17)
            }
        }
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
    }

    private var securitySection: some View {
        VStack(spacing: 0) {
            Toggle(viewModel.resources.securityPinCodeTitle,
                   isOn: $viewModel.isPinCodeOn)
            .background(.white)
            .frame(height: 44)
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
                SecurityAdvancedCellView(title: viewModel.resources.securityBiometryEnterTitle,
                                         description: viewModel.resources.securityBiometryEnterState,
                                         currentState: $viewModel.isBiometryOn)
                .frame(height: 44)
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
                    .frame(height: 44)
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
                PrivacyCellView(item: type,
                                phraseStatus: viewModel.isPhraseExist())
                .background(viewModel.resources.background)
                .listRowSeparator(.visible,
                                  edges: .bottom)
                .frame(height: 73)
                .onTapGesture {
                    if viewModel.isPhraseExist() {
                        viewModel.send(.onPhrase)
                    } else {
                        showAddWallet = true
                    }
                }
            case .session:
                PrivacyCellView(item: type)
                .background(viewModel.resources.background)
                .frame(height: 57)
                .listRowSeparator(.visible,
                                  edges: .top)
                .onTapGesture {
                    viewModel.send(.onSession)
                }
            case .blockList:
                PrivacyCellView(item: type)
                .background(viewModel.resources.background)
                .frame(height: 44)
                .onTapGesture {
                    viewModel.send(.onBlockList)
                }
            default:
                EmptyView()
            }
        }
    }
}
