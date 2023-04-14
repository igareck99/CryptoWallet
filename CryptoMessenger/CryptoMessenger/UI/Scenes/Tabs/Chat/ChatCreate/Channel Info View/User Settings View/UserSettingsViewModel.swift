import SwiftUI

// MARK: - UserSettingsViewModelProtocol

protocol UserSettingsViewModelProtocol: ObservableObject {

    var items: [any ViewGeneratable] { get }

    var showShowChangeRole: Binding<Bool> { get set }

    var showUserProfile: Binding<Bool> { get set }

    func onTapRemoveUser()

    func onTapChangeRole()

    func onTapShowProfile()
}

// MARK: - UserSettingsViewModel

final class UserSettingsViewModel {

    // MARK: - Private Properties

    private let userId: Binding<String>
    private var showBottomSheet: Binding<Bool>
    private let roomId: String
    private let roleCompare: ChannelUserActions
    private let matrixUseCase: MatrixUseCaseProtocol
    private let factory: UserSettingsFactoryProtocol.Type
    private let onActionEnd: VoidBlock
    private let onUserProfile: VoidBlock

    // MARK: - Internal Properties

    var items = [any ViewGeneratable]() {
        didSet {
            objectWillChange.send()
        }
    }

    private var showShowChangeRoleState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var showShowChangeRole: Binding<Bool> = .init(
        get: {
            self.showShowChangeRoleState
        },
        set: { newValue in
            self.showShowChangeRoleState = newValue
        }
    )

    private var showUserProfileState: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }

    lazy var showUserProfile: Binding<Bool> = .init(
        get: {
            self.showUserProfileState
        },
        set: { newValue in
            self.showUserProfileState = newValue
        }
    )

    // MARK: - Lifecycle

    init(
        userId: Binding<String>,
        showBottomSheet: Binding<Bool>,
        showUserProfile: Binding<Bool>,
        roomId: String,
        roleCompare: ChannelUserActions,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        factory: UserSettingsFactoryProtocol.Type = UserSettingsFactory.self,
        onActionEnd: @escaping VoidBlock,
        onUserProfile: @escaping VoidBlock
    ) {
        self.userId = userId
        self.showBottomSheet = showBottomSheet
        self.roomId = roomId
        self.roleCompare = roleCompare
        self.matrixUseCase = matrixUseCase
        self.factory = factory
        self.onActionEnd = onActionEnd
        self.onUserProfile = onUserProfile
        self.items = factory.makeItems(roleCompare, viewModel: self)
        self.showUserProfile = showUserProfile
    }
}

// MARK: - UserSettingsViewModelProtocol

extension UserSettingsViewModel: UserSettingsViewModelProtocol {

    func onTapShowProfile() {
        onUserProfile()
        delay(1) {
            self.showUserProfile.wrappedValue = true
        }
    }

    func onTapRemoveUser() {
        guard let matrixId = UserIdValidator.makeValidId(userId: userId.wrappedValue) else { return }
        debugPrint("\(matrixId)")
        matrixUseCase.kickUser(
            userId: matrixId,
            roomId: roomId,
            reason: "kicked"
        ) { [weak self] in
            debugPrint("matrixUseCase.kickUser result: \($0)")
            guard case .success = $0 else { return }
            self?.onActionEnd()
        }
    }

    func onTapChangeRole() {
        showBottomSheet.wrappedValue = true
        onActionEnd()
    }
}
