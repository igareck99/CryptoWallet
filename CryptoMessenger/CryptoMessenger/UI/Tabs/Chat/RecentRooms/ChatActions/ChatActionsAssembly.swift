import SwiftUI

// MARK: - ChatActionsAssembly

enum ChatActionsAssembly {

    // MARK: - Static Methods

    static func build(_ room: ChatActionsList,
                      onSelect: @escaping GenericBlock<ChatActions>,
                      viewHeight: @escaping GenericBlock<CGFloat>) -> some View {
        let view = ChatActionsView(room: room, onSelect: { value in
            onSelect(value)
        }, viewHeight: { value in
            viewHeight(value)
        })
        return view
    }
}
