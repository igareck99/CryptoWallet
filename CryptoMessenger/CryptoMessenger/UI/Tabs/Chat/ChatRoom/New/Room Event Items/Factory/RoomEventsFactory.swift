import Foundation

protocol RoomEventsFactoryProtocol {

    static func makeSystemEventItem(
        date: String,
        text: String,
        type: SystemEventType,
        onTap: @escaping () -> Void
    ) -> SystemEventItem

    static func makeReplyItem(
        date: String,
        repliedItemId: String,
        text: String,
        reactionItems: [ReactionTextsItem],
        readStatus: EventStatus,
        onTap: @escaping () -> Void,
        onReplyTap: @escaping () -> Void
    ) -> ReplyItem

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
