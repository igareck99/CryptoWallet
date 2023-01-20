import Foundation

protocol ChannelInfoViewModelProtocol: ObservableObject {
    
    var isSnackbarPresented: Bool { get set }
    
    func onChannelLinkCopy()
    
    func onDeleteUserFromChannel()
    
    func onInviteUserFromChannel()
    
    func onBanUserFromChannel()
    
    func onUnbanUserFromChannel()
    
}

final class ChannelInfoViewModel {
    
    var isSnackbarPresented = false
    
    private let matrixUseCase: MatrixUseCaseProtocol
    
    init(
        matrixUseCase: MatrixUseCaseProtocol = MatrixUseCase.shared
    ) {
        self.matrixUseCase = matrixUseCase
    }
    
}

// MARK: - ChannelInfoViewModelProtocol

extension ChannelInfoViewModel: ChannelInfoViewModelProtocol {
    
    func onChannelLinkCopy() {
        isSnackbarPresented = true
        objectWillChange.send()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.isSnackbarPresented = false
            self?.objectWillChange.send()
        }
    }
    
    func onDeleteUserFromChannel() {
        matrixUseCase.kickUser(
            userId: "",
            roomId: "",
            reason: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }
    
    func onInviteUserFromChannel() {
        matrixUseCase.inviteUser(
            userId: "",
            roomId: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }
    
    func onBanUserFromChannel() {
        matrixUseCase.banUser(
            userId: "",
            roomId: "",
            reason: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }
    
    func onUnbanUserFromChannel() {
        matrixUseCase.unbanUser(
            userId: "",
            roomId: ""
        ) { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }
    
    func onLeaveRoom() {
        matrixUseCase.leaveRoom(roomId: "") { result in
            debugPrint("onDeleteUserFromChannel: \(result)")
        }
    }
}
