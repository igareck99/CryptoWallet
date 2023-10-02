import SwiftUI

// MARK: - ActionSheetViewAssembly

enum ActionSheetViewAssembly {

    static func build(_ tappedAction: @escaping (AttachAction) -> Void,
                      _ onCamera: @escaping () -> Void,
                      _ onSendPhoto: @escaping (UIImage) -> Void) -> some View {
        let viewModel = AttachActionViewModel(tappedAction: tappedAction,
                                              onCamera: onCamera,
                                              onSendPhoto: onSendPhoto)
        let view = ActionSheetNewView(viewModel: viewModel)
        return view
    }
}
