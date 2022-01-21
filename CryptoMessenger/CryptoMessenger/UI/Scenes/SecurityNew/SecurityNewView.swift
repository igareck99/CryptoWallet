import SwiftUI

// MARK: - SecurityNewView

struct SecurityNewView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: SecurityNewViewModel
    @StateObject var blockListViewModel = BlockListViewModel()

    // MARK: - Private Properties

    @State private var activatePinCode = true
    @State private var activateBiometry = false
    @State private var activateFalsePassword = false
    @State private var showTelephoneActionSheet = false

    // MARK: - Body

    var body: some View {
        Divider().padding(.top, 20)
        List {
            Text(R.string.localizable.securitySecurity())
                .font(.bold(12))
                .foreground(.darkGray())
                .listRowSeparator(.hidden)
            Toggle(R.string.localizable.securityPinCodeTitle(), isOn: $activatePinCode)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .listRowSeparator(.hidden)
                        if activatePinCode {
                            SecurityAdvancedCellView(title: R.string.localizable.securityBiometryEnterTitle(),
                                                     description: R.string.localizable.securityBiometryEnterState(),
                                                     currentState: $activateBiometry)
                                .listRowSeparator(.hidden)
                            SecurityAdvancedCellView(title: R.string.localizable.securityFalsePasswordTitle(),
                                                     description: R.string.localizable.securityFalsePasswordState(),
                                                     currentState: $activateFalsePassword)
                                .listRowSeparator(.hidden)
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
                case .telephone:
                    SecurityCellView(title: type.result.title,
                                     currentState: viewModel.telephoneSeeState)
                        .background(.white())
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showTelephoneActionSheet = true
                    }
                default:
                    SecurityCellView(title: type.result.title,
                                     currentState: type.result.state)
                        .background(.white())
                    .listRowSeparator(.hidden)
                }
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
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
//        .actionSheet(isPresented: $showTelephoneActionSheet, titleVisibility: .hidden) {
//            ActionSheet(
//                title: Text(""),
//                buttons: [
//                    .default(Text(R.string.localizable.securityProfileObserveState())) {
//                        viewModel.updateTelephoneState(item: R.string.localizable.securityProfileObserveState())
//                    },
//                        .default(Text(R.string.localizable.securityContactsAll())) {
//                            viewModel.updateTelephoneState(item: R.string.localizable.securityContactsAll())
//                        },
//                        .default(Text(R.string.localizable.profileViewingNobody())) {
//                            viewModel.updateTelephoneState(item: R.string.localizable.profileViewingNobody())
//                        },
//                    .destructive(Text(R.string.localizable.personalizationCancel()))
//                ]
//            )
//        }
        .listStyle(.inset)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.securityTitle())
                    .font(.bold(15))
            }
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
                Text(currentState)
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
