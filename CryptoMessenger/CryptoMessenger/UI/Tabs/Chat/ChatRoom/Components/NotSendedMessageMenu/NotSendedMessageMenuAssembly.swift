import SwiftUI

enum NotSendedMessageMenuAssembly {
    static func build(
        _ item: RoomEvent,
        _ onTapItem: @escaping (NotSendedMessage, RoomEvent) -> Void
    ) -> some View {
        let view = NotSendedMessageMenu(
            item: item,
            onTapItem: onTapItem
        )
        return view
    }
}
