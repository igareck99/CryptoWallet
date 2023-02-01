import SwiftUI

protocol UserSettingsViewModelProtocol: ObservableObject {
    
    var items: [any ViewGeneratable] { get }
    
    var showShowChangeRole: Binding<Bool> { get set }
    
    var showUserProfile: Binding<Bool> { get set }
    
    func onTapRemoveUser()
    
    func onTapChangeRole()
    
    func onTapShowProfile()
}

final class UserSettingsViewModel {
    
    private let userId: Binding<String>
    private var showBottomSheet: Binding<Bool>
    private let roomId: String
    private let matrixUseCase: MatrixUseCaseProtocol
    private let factory: UserSettingsFactoryProtocol.Type
    private let onActionEnd: VoidBlock
    
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

    init(
        userId: Binding<String>,
        showBottomSheet: Binding<Bool>,
        showUserProfile: Binding<Bool>,
        roomId: String,
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared,
        factory: UserSettingsFactoryProtocol.Type = UserSettingsFactory.self,
        onActionEnd: @escaping VoidBlock
    ) {
        self.userId = userId
        self.showBottomSheet = showBottomSheet
        self.roomId = roomId
        self.matrixUseCase = matrixUseCase
        self.factory = factory
        self.onActionEnd = onActionEnd
        self.items = factory.makeItems(viewModel: self)
        self.showUserProfile = showUserProfile
    }
}

// MARK: - UserSettingsViewModelProtocol

extension UserSettingsViewModel: UserSettingsViewModelProtocol {
    
    func onTapShowProfile() {
        showUserProfile.wrappedValue = true
        onActionEnd()
    }
    
    func onTapRemoveUser() {
        
        guard let matrixId = UserIdValidator.makeValidId(userId: userId.wrappedValue) else { return } 
        
        debugPrint("\(matrixId)")
        self.onActionEnd()
        
        matrixUseCase.kickUser(
            userId: matrixId,
            roomId: roomId,
            reason: "kicked"
        ) { [weak self] in
            debugPrint("matrixUseCase.kickUser result: \($0)")
            guard case .success = $0 else { return }
        }
    }
    
    func onTapChangeRole() {
        showBottomSheet.wrappedValue = true
        onActionEnd()
    }
}
