// JitsiWidgetData represents Jitsi widget data according to Matrix Widget API v2
@objcMembers
final class JitsiWidgetData: MXJSONModel {

	// The domain of the Jitsi server (eg: “jitsi.riot.im”)
	let domain: String

	// The ID of the Jitsi conference
	let conferenceId: String

	// true if the Jitsi conference is intended to be an audio-only call
	let isAudioOnly: Bool

	// Indicate the authentication supported by the Jitsi server
	// if any otherwise nil if there is no authentication supported.
	var authenticationType: String?

	init(
		domain: String,
		conferenceId: String,
		isAudioOnly: Bool,
		authenticationType: String? = nil
	) {
		self.domain = domain
		self.conferenceId = conferenceId
		self.isAudioOnly = isAudioOnly
		self.authenticationType = authenticationType
		super.init()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static func model(dictionary: [AnyHashable: Any]) -> JitsiWidgetData? {

		guard
			let conferenceId = dictionary["conferenceId"] as? String,
			let domain: String = dictionary["domain"] as? String
		else { return nil }

		let isAudioOnly: Bool = dictionary["isAudioOnly"] as? Bool ?? false
		let authenticationType: String? = dictionary["auth"] as? String

		let model = JitsiWidgetData(
			domain: domain,
			conferenceId: conferenceId,
			isAudioOnly: isAudioOnly,
			authenticationType: authenticationType
		)
		return model
	}

	override func jsonDictionary() -> [AnyHashable: Any] {
		var dict: [String: Any] = [
			"domain": domain,
			"conferenceId": conferenceId,
			"isAudioOnly": isAudioOnly
		]

		if let authType = authenticationType { dict["auth"] = authType }

		return dict
	}
}
