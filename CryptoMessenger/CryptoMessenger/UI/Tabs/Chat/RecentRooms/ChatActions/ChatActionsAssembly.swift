import SwiftUI

// MARK: - ChatActionsAssembly

enum ChatActionsAssembly {

    // MARK: - Static Methods

    static func build(_ roomId: String,
                      onSelect: @escaping GenericBlock<ChatActions>) -> some View {
        let view = ChatActionsView(roomId: roomId, onSelect: { value in
            onSelect(value)
        })
        return view
    }
}
