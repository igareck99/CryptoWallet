import SwiftUI

enum ActionSheetViewAssembly {
    static func build(model: ActionsViewModel) -> some View {
        let viewModel = AttachActionViewModel(
            interlocutorId: model.interlocutorId,
            isDirectChat: model.isDirect,
            tappedAction: model.tappedAction,
            onCamera: model.onCamera,
            onSendPhoto: model.onSendPhoto
        )
        let view = ActionSheetNewView(viewModel: viewModel)
        return view
    }
}
