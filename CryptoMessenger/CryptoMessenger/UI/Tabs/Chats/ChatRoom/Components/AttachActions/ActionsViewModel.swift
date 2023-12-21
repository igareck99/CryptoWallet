import UIKit

struct ActionsViewModel {
    let interlocutorId: String?
    let isDirect: Bool
    let tappedAction: (AttachAction) -> Void
    let onCamera: () -> Void
    let onSendPhoto: (UIImage) -> Void

    init(
        interlocutorId: String? = nil,
        isDirect: Bool,
        tappedAction: @escaping (AttachAction) -> Void,
        onCamera: @escaping () -> Void,
        onSendPhoto: @escaping (UIImage) -> Void
    ) {
        self.interlocutorId = interlocutorId
        self.isDirect = isDirect
        self.tappedAction = tappedAction
        self.onCamera = onCamera
        self.onSendPhoto = onSendPhoto
    }
}
