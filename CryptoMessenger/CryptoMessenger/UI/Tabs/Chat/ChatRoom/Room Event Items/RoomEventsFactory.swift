import Foundation

protocol RoomEventsFactoryProtocol {
    static func makeTextItem(
        date: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> TextItem

    static func makeSystemEventItem(
        date: String,
        text: String,
        type: SystemEventType,
        onTap: @escaping () -> Void
    ) -> SystemEventItem

    static func makeDocumentItem(
        date: String,
        url: URL,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> DocumentItem

    static func makeReplyItem(
        date: String,
        repliedItemId: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void,
        onReplyTap: @escaping () -> Void
    ) -> ReplyItem

    static func makeContactItem(
        date: String,
        contact: Contact,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> ContactItem

    static func makeCallItem(
        date: String,
        callStateText: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> CallItem

    static func makeLocationItem(
        date: String,
        coordinate: Coordinate,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> LocationItem

    static func makeAudioItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> AudioItem

    static func makeVideoItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> VideoItem

    static func makeImageItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> ImageItem
}

enum RoomEventsFactory: RoomEventsFactoryProtocol {
    static func makeTextItem(
        date: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> TextItem {
        TextItem(
            date: date,
            text: text,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeSystemEventItem(
        date: String,
        text: String,
        type: SystemEventType,
        onTap: @escaping () -> Void
    ) -> SystemEventItem {
        SystemEventItem(
            date: date,
            text: text,
            type: type,
            onTap: onTap
        )
    }

    static func makeDocumentItem(
        date: String,
        url: URL,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> DocumentItem {
        DocumentItem(
            date: date,
            url: url,
            text: text,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeReplyItem(
        date: String,
        repliedItemId: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void,
        onReplyTap: @escaping () -> Void
    ) -> ReplyItem {
        ReplyItem(
            date: date,
            repliedItemId: repliedItemId,
            text: text,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap,
            onReplyTap: onReplyTap
        )
    }

    static func makeContactItem(
        date: String,
        contact: Contact,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> ContactItem {
        ContactItem(
            date: date,
            contact: contact,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeCallItem(
        date: String,
        callStateText: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> CallItem {
        CallItem(
            date: date,
            callStateText: callStateText,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeLocationItem(
        date: String,
        coordinate: Coordinate,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> LocationItem {
        LocationItem(
            date: date,
            coordinate: coordinate,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeAudioItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> AudioItem {
        AudioItem(
            date: date,
            url: url,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeVideoItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> VideoItem {
        VideoItem(
            date: date,
            url: url,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }

    static func makeImageItem(
        date: String,
        url: URL,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void
    ) -> ImageItem {
        ImageItem(
            date: date,
            url: url,
            reactionItems: reactionItems,
            readStatus: readStatus,
            onTap: onTap
        )
    }
}
