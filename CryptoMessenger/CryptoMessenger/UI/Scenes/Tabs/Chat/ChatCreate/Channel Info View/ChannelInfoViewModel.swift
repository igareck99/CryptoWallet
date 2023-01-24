import Foundation

// MARK: - ChannelInfoViewModelProtocol

protocol ChannelInfoViewModelProtocol: ObservableObject {

    var isSnackbarPresented: Bool { get set }

    func onChannelLinkCopy()

    func onDeleteUserFromChannel()

    func onInviteUserFromChannel()

    func onBanUserFromChannel()

    func onUnbanUserFromChannel()

    func getChannelUsers() -> [ChannelParticipantsData]

    func updateUserRole(mxId: String, userRole: ChannelRole)
}

// MARK: - ChannelInfoViewModel

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

    func getChannelUsers() -> [ChannelParticipantsData] {
        return [.init(name: "Валерия Ластко", matrixId: "@mn50hdbcj9tegd", role: .admin),
                .init(name: "Данил Даньшин", matrixId: "@mndjajdjsjdtegd", role: .owner),
                .init(name: "Даниил Петров", matrixId: "@mn57jjjj3433gd", role: .user)]
    }
    
    func updateUserRole(mxId: String, userRole: ChannelRole) {
        debugPrint("Rolw of \(mxId)  is updated to \(userRole)")
    }
}
