import SwiftUI

protocol ChatComponentsFactoryProtocol {
	func makeChatEventView(event: RoomMessage, viewModel: ChatRoomViewModel) -> AnyView
}

struct ChatComponentsFactory {

	private enum Constants {
		static let rejectCallKey = "m.call.reject"
		static let hangupCallKey = "m.call.hangup"

		static let reasonKey = "reason"
		static let userHangupReasonKey = "user_hangup"
		static let inviteTimeoutReasonKey = "invite_timeout"
	}

	private let sources: ChatRoomSourcesable.Type

	init(
		sources: ChatRoomSourcesable.Type = ChatRoomResources.self
	) {
		self.sources = sources
	}
}

// MARK: - ChatComponentsFactoryProtocol

extension ChatComponentsFactory: ChatComponentsFactoryProtocol {

	func makeChatEventView(event: RoomMessage, viewModel: ChatRoomViewModel) -> AnyView {

		if event.eventType.contains("m.call.hangup") ||
			event.eventType.contains("m.call.reject") {
			let eventTitle = textForCallEventReason(eventType: event.eventType, content: event.content)
			return AnyView(
				CallEventView(
					eventTitle: eventTitle,
					eventDateTime: event.shortDate,
					isFromCurrentUser: event.isCurrentUser
				) {
					debugPrint("CALL TAPPED")
					viewModel.p2pVoiceCallPublisher.send()
				}
					.flippedUpsideDown()
					.shadow(color: Color(.black222222(0.2)), radius: 0, x: 0, y: 0.4)
			)
		}

		if event.eventType == "m.room.encryption" {
			return AnyView(
				ChatEventView(
					text: sources.chatRoomViewSelfAvatarChange,
					foregroundColor: .white
				)
				.configureOuterShadow()
				.flippedUpsideDown()
			)
		}

		if event.eventType == "m.room.avatar" {
			return AnyView(
				ChatEventView(
					text: sources.chatRoomViewEncryptedMessages,
					foregroundColor: .white
				)
				.configureOuterShadow()
				.flippedUpsideDown()
			)
		}

		guard event.eventType == "m.room.member",
			  let membership = event.content["membership"] as? String else {
			return AnyView(EmptyView())
		}

		let displayName: String = (event.content["displayname"] as? String) ?? ""

		let text: String

		switch membership {
		case "join":
			let users = viewModel.roomUsers.filter({ $0.displayname == displayName })
			if users.contains(where: { $0.avatarUrl == event.content["avatar_url"] as? String }) {
				text = "\(displayName) \(sources.chatRoomViewAvatarChange)"
			} else {
				text = ""
			}
		case "leave":
			text = "\(displayName) \(sources.chatRoomViewLeftTheRoom)"
		case "invite":
			text = "\(displayName) \(sources.chatRoomViewInvited)"
		case "unknown":
			text = sources.chatRoomViewUnownedError
		case "ban":
			text = "Пользователь \(displayName) \(sources.chatRoomViewBanned)"
		default:
			return AnyView(EmptyView())
		}

		return AnyView(
			ChatEventView(text: text, foregroundColor: .white)
				.configureOuterShadow()
				.flippedUpsideDown()
		)
	}

	private func textForCallEventReason(
		eventType: String,
		content: [String: Any]
	) -> String {

		if eventType == Constants.rejectCallKey {
			return sources.callDeclined
		}

		if eventType == Constants.hangupCallKey,
		   let reason = content[Constants.reasonKey] as? String,
		   reason == Constants.inviteTimeoutReasonKey {
			return sources.callMissed
		}
		return sources.callFinished
	}
}
