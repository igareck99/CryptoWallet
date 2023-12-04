import UIKit

struct ActionsViewModel {
    let interlocutorId: String?
    let tappedAction: (AttachAction) -> Void
    let onCamera: () -> Void
    let onSendPhoto: (UIImage) -> Void

    init(
        interlocutorId: String? = nil,
        tappedAction: @escaping (AttachAction) -> Void,
        onCamera: @escaping () -> Void,
        onSendPhoto: @escaping (UIImage) -> Void
    ) {
        self.interlocutorId = interlocutorId
        self.tappedAction = tappedAction
        self.onCamera = onCamera
        self.onSendPhoto = onSendPhoto
    }
}
