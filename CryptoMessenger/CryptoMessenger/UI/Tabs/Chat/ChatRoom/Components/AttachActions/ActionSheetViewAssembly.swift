import SwiftUI

// MARK: - ActionSheetViewAssembly

enum ActionSheetViewAssembly {
    static func build(model: ActionsViewModel) -> some View {
        let viewModel = AttachActionViewModel(
            interlocutorId: model.interlocutorId,
            tappedAction: model.tappedAction,
            onCamera: model.onCamera,
            onSendPhoto: model.onSendPhoto
        )
        let view = ActionSheetNewView(viewModel: viewModel)
        return view
    }
}

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
