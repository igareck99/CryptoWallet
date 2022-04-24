import SwiftUI
import LocalAuthentication

// MARK: - SecurityNewView

struct SecurityNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: SecurityNewViewModel
    @StateObject var blockListViewModel = BlockListViewModel()

    // MARK: - Private Properties

    @State private var activateBiometry = false
    @State private var showProfileObserveSheet = false
    @State private var showLastSeenSheet = false
    @State private var showCallsSheet = false
    @State private var showGeopositionSheet = false
    @State private var showTelephoneActionSheet = false
    @State private var showBiometryErrorAlert = false

    // MARK: - Body

    var body: some View {
        Divider().padding(.top, 16)
        List {
            Text(R.string.localizable.securitySecurity())
                .font(.bold(12))
                .foreground(.darkGray())
                .listRowSeparator(.hidden)
            Toggle(R.string.localizable.securityPinCodeTitle(),
                   isOn: $viewModel.isPinCodeOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .listRowSeparator(.hidden)
                .onAppear {
                    if viewModel.isPinCodeUpdate() {
                        viewModel.dataIsUpdated = true
                    }
                }
                .onChange(of: viewModel.isPinCodeOn) { value in
                    if viewModel.userSettings.isLocalAuth != viewModel.isPinCodeOn {
                        if value {
                            viewModel.send(.onCreatePassword)
                        } else {
                            viewModel.send(.onApprovePassword)
                        }
                    }
                }
            if viewModel.isPinCodeOn {
                SecurityAdvancedCellView(title: R.string.localizable.securityBiometryEnterTitle(),
                                         description: R.string.localizable.securityBiometryEnterState(),
                                         currentState: $viewModel.isBiometryOn)
                    .listRowSeparator(.hidden)
                    .onChange(of: viewModel.isBiometryOn) { item in
                        if item {
                            authenticate()
                        } else {
                            viewModel.updateIsBiometryOn(item: false)
                        }
                    }
                SecurityAdvancedCellView(title: R.string.localizable.securityFalsePasswordTitle(),
                                         description: R.string.localizable.securityFalsePasswordState(),
                                         currentState: $viewModel.isFalsePinCodeOn)
                    .listRowSeparator(.hidden)
                    .onChange(of: viewModel.isFalsePinCodeOn) { item in
                        if item {
                            viewModel.send(.onFalsePassword)
                        } else {
                            viewModel.updateIsFalsePinCode(item: false)
                        }
                    }
            }
            Divider()
            Text(R.string.localizable.securityPrivacy())
                .font(.bold(12))
                .foreground(.darkGray())
                .listRowSeparator(.hidden)
            ForEach(SecurityCellItem.allCases, id: \.self) { type in
                switch type {
                case .blackList:
                    SecurityCellView(title: R.string.localizable.securityBlackListTitle(),
                                     font: .blue(),
                                     currentState: String(blockListViewModel.listData.count))
                        .background(.white())
                        .listRowSeparator(.hidden)
                        .onTapGesture { viewModel.send(.onBlockList) }
                case .profileObserve:
                    SecurityCellView(title: type.result.title,
                                     currentState: viewModel.profileObserveState)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showProfileObserveSheet = true
                    }
                case .lastSeen:
                    SecurityCellView(title: type.result.title,
                                     currentState: viewModel.lastSeenState)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showLastSeenSheet = true
                    }
                case .calls:
                    SecurityCellView(title: type.result.title,
                                     currentState: viewModel.callsState)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showCallsSheet = true
                    }
                case .geoposition:
                    SecurityCellView(title: type.result.title,
                                     currentState: viewModel.geopositionState)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showGeopositionSheet = true
                    }
                case .telephone:
                    SecurityCellView(title: type.result.title,
                                     currentState: viewModel.telephoneState)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showTelephoneActionSheet = true
                    }
                case .session:
                    SecurityCellView(title: type.result.title,
                                     currentState: type.result.state)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.send(.onSession)
                    }
                }
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .onDisappear {
            showTabBar()
        }
        .alert(isPresented: $showBiometryErrorAlert, content: {
            Alert(title: Text("Биометрия недоступна"), message: nil,
                  dismissButton: .default(Text("OK")))
        })
        .confirmationDialog("", isPresented: $showProfileObserveSheet, titleVisibility: .hidden) {
            ForEach([R.string.localizable.securityProfileObserveState(),
                     R.string.localizable.securityContactsAll(),
                     R.string.localizable.profileViewingNobody()], id: \.self) { item in
                Button(item) {
                    viewModel.updateProfileObserveState(item: item)
                }
            }
        }
        .confirmationDialog("", isPresented: $showLastSeenSheet, titleVisibility: .hidden) {
            ForEach([R.string.localizable.securityProfileObserveState(),
                     R.string.localizable.securityContactsAll(),
                     R.string.localizable.profileViewingNobody()], id: \.self) { item in
                Button(item) {
                    viewModel.updateLastSeenState(item: item)
                }
            }
        }
        .confirmationDialog("", isPresented: $showCallsSheet, titleVisibility: .hidden) {
            ForEach([R.string.localizable.securityProfileObserveState(),
                     R.string.localizable.securityContactsAll(),
                     R.string.localizable.profileViewingNobody()], id: \.self) { item in
                Button(item) {
                    viewModel.updateCallsState(item: item)
                }
            }
        }
        .confirmationDialog("", isPresented: $showGeopositionSheet, titleVisibility: .hidden) {
            ForEach([R.string.localizable.securityProfileObserveState(),
                     R.string.localizable.securityContactsAll(),
                     R.string.localizable.profileViewingNobody()], id: \.self) { item in
                Button(item) {
                    viewModel.updateGeopositionState(item: item)
                }
            }
        }
        .confirmationDialog("", isPresented: $showTelephoneActionSheet, titleVisibility: .hidden) {
            ForEach([R.string.localizable.securityProfileObserveState(),
                     R.string.localizable.securityContactsAll(),
                     R.string.localizable.profileViewingNobody()], id: \.self) { item in
                Button(item) {
                    viewModel.updateTelephoneState(item: item)
                }
            }
        }
        .listStyle(.inset)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.securityTitle())
                    .font(.bold(15))
            }
        }
    }

    // MARK: - Private Properties

    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Something"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                   DispatchQueue.main.async {
                        if success {
                            viewModel.isBiometryOn = true
                            viewModel.updateIsBiometryOn(item: true)
                        } else {
                            viewModel.isBiometryOn = false
                            viewModel.updateIsBiometryOn(item: false)
                        }
                    }
                }
            } else {
                viewModel.isBiometryOn = false
                viewModel.updateIsBiometryOn(item: false)
                showBiometryErrorAlert = true
            }
    }
}

// MARK: - SecurityCellView

struct SecurityCellView: View {

    // MARK: - Internal Properties

    var title: String
    var font: Palette = .darkGray()
    var currentState: String

    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .font(.regular(15))
            Spacer()
            HStack(spacing: 17) {
                Text(currentState.isEmpty ? R.string.localizable.securityProfileObserveState() :
                        currentState)
                    .font(.regular(15))
                    .foreground(font)
                R.image.registration.arrow.image
            }
        }
    }
}

// MARK: - SecurityAdvancedCellView

struct SecurityAdvancedCellView: View {

    // MARK: - Internal Properties

    var title: String
    var description: String
    @Binding var currentState: Bool

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.regular(15))
                Text(description)
                    .font(.regular(12))
                    .foreground(.gray())
            }
            Spacer()
            Toggle("", isOn: $currentState)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
    }
}

// MARK: - SecurityCellItem

enum SecurityCellItem: CaseIterable, Identifiable {

    // MARK: - Types

    case profileObserve, lastSeen, calls, geoposition, telephone, session, blackList

    // MARK: - Internal Properties

    var id: UUID { UUID() }
    var result: (title: String, state: String) {
        switch self {
        case .profileObserve:
            return (R.string.localizable.securityProfileObserve(),
                    R.string.localizable.securityProfileObserveState())
        case .lastSeen:
            return (R.string.localizable.securityLastSeen(),
                    R.string.localizable.securityLastSeen())
        case .calls:
            return (R.string.localizable.securityCallsTitle(),
                    R.string.localizable.securityContactsAll())
        case .geoposition:
            return (R.string.localizable.securityGeoposition(),
                    R.string.localizable.securityContactsAll())
        case .telephone:
            return (R.string.localizable.securityTelephone(),
                    R.string.localizable.securityContactsAll())
        case .session:
            return (R.string.localizable.securitySessionTitle(),
                    R.string.localizable.securitySessionState())
        case .blackList:
            return (R.string.localizable.securityBlackListTitle(),
                    "3")
        }
    }}
