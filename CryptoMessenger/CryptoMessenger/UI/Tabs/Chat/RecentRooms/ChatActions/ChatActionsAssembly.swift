import SwiftUI

enum ChatActionsAssembly {
    static func build(
        room: ChatActionsList,
        onSelect: @escaping GenericBlock<ChatActions>
    ) -> some View {
        let view = ChatActionsView(room: room, onSelect: { value in
            onSelect(value)
        })
        return view
    }
}
