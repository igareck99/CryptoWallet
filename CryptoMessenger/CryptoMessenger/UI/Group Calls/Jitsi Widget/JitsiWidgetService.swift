// swiftlint: disable: all

import Foundation
import MatrixSDK

// Всю логику что была в ObjC модели Widget перенес сюда
@objcMembers
final class JitsiWidgetService: NSObject {

	private let mxSession: MXSession

	init(mxSession: MXSession) {
		self.mxSession = mxSession
	}

	@discardableResult
	func makeWidgetUrl(
		widget: JitsiWidget,
		success: @escaping (String) -> Void,
		failure: @escaping () -> Void
	) -> MXHTTPOperation? {
		makeWidgetUrl(
			widget: widget) { result in
				guard case let .success(widgetUrl) = result else { failure(); return }
				success(widgetUrl)
			}
	}

	@discardableResult
	func makeWidgetUrl(
		widget: JitsiWidget,
		completion: @escaping (EmptyFailureResult<String>) -> Void
	) -> MXHTTPOperation? {

		guard
			var widgetUrl = widget.url,
			let userId = MXTools.encodeURIComponent(mxSession.myUser.userId)
		else { fatalError("widget.url doesn't exist") }

		// Format the url string with user data
		var displayName = mxSession.myUser.displayname ?? mxSession.myUser.userId ?? ""
		var avatarUrl = mxSession.myUser.avatarUrl ?? ""
		var widgetId = widget.widgetId

		// Escape everything to build a valid URL string
		// We can't know where the values escaped here will be inserted in the URL, so the alphanumeric charset is used
		displayName = MXTools.encodeURIComponent(displayName)
		avatarUrl = MXTools.encodeURIComponent(avatarUrl)
		widgetId = MXTools.encodeURIComponent(widgetId)

		widgetUrl = widgetUrl.replacingOccurrences(of: "$matrix_user_id", with: userId)
		widgetUrl = widgetUrl.replacingOccurrences(of: "$matrix_display_name", with: displayName)
		widgetUrl = widgetUrl.replacingOccurrences(of: "$matrix_avatar_url", with: avatarUrl)
		widgetUrl = widgetUrl.replacingOccurrences(of: "$matrix_widget_id", with: widgetId)

		if let roomId = MXTools.encodeURIComponent(widget.roomId) {
			widgetUrl = widgetUrl.replacingOccurrences(of: "$matrix_room_id", with: roomId)
		}

		// Integrate widget data into widget url
		widget.data?.forEach { obj in
			let paramKey = "$\(obj.key)"

			guard let widgetDataValue = widget.data?[obj.key]else {
				fatalError("[Widget] Error: Invalid data field value in \(self) for key \(obj.key) in data \(widget.data)")
			}

			let dataString = "\(widgetDataValue)"
			// same question as above
			let value = MXTools.encodeURIComponent(dataString)
			widgetUrl = widgetUrl.replacingOccurrences(of: paramKey, with: value ?? "")
		}

		// Add the widget id
		let separator = widgetUrl.contains("?") ? "&" : "?"
		widgetUrl = widgetUrl + separator + "widgetId=" + widget.widgetId

		// Check if their scalar token must added
		guard isScalar(url: widgetUrl, userId: userId) else {
			completion(.success(widgetUrl))
			return nil
		}

		getScalarToken(
			session: mxSession,
			validate: true) { result in
				guard case let .success(scalarToken) = result else { completion(.failure); return }
				// Add the user scalar token
				widgetUrl = widgetUrl + "&scalar_token=" + scalarToken
				completion(.success(widgetUrl))
			}
		return nil
	}

	func isScalar(url: String, userId: String) -> Bool {
		// TODO: Do we need to add `integrationsWidgetsUrls` to `WidgetManagerConfig`?
		var scalarUrlStrings = [
			"https://scalar.vector.im/_matrix/integrations/v1",
			"https://scalar.vector.im/api",
			"https://scalar-staging.vector.im/_matrix/integrations/v1",
			"https://scalar-staging.vector.im/api",
			"https://scalar-staging.riot.im/scalar/api"
		]

		// Так реализовано в element
		// Видимо scalarUrlStrings будет(должен) формироваться динамически
		if scalarUrlStrings.isEmpty {
			if let apiUrl = self.mxSession.homeserverWellknown.integrations?.managers.first?.apiUrl {
				scalarUrlStrings = [apiUrl]
			}
			scalarUrlStrings = ["https://scalar.vector.im/api"]
		}
		return scalarUrlStrings.first { url.hasPrefix($0) } != nil
	}

	@discardableResult
	func getScalarToken(
		session: MXSession,
		validate: Bool,
		completion: @escaping (EmptyFailureResult<String>) -> Void
	) -> MXHTTPOperation? {
		registerForScalarToken(session: session, completion: completion)
	}

	@discardableResult
	func registerForScalarToken(
		session: MXSession,
		completion: @escaping (EmptyFailureResult<String>) -> Void
	) -> MXHTTPOperation? {

		let apiUrl: String? = session.homeserverWellknown?.integrations?.managers.first?.apiUrl

		var operation1: MXHTTPOperation?
		operation1 = session.matrixRestClient.openIdToken { openIdToken in
			// Exchange the token for a scalar token
			var client = MXHTTPClient.init(baseURL: apiUrl, andOnUnrecognizedCertificateBlock: nil)

			var operation2 = client?.request(
				withMethod: "POST",
				path: "register?v=1.1",
				parameters: openIdToken?.jsonDictionary(),
				success: { jsonResponse in
					client = nil
					guard let scalarToken = jsonResponse?["scalar_token"] as? String else { completion(.failure); return }

					// Validate it (this mostly checks to see if the IM needs us to agree to some terms)
					var operation3 = self.validate(
						scalarToken: scalarToken,
						session: session) { result in
							guard case .success(_) = result else { completion(.failure); return }
							completion(.success(scalarToken))
						}
					operation1?.mutate(to: operation3)
				},
				failure: { _ in
					client = nil
					completion(.failure)
				}
			)
			operation1?.mutate(to: operation2)
		} failure: { _ in
			completion(.failure)
		}
		return operation1
	}

	@discardableResult
	func validate(
		scalarToken: String,
		session: MXSession,
		completion: @escaping (EmptyFailureResult<Bool>) -> Void
	) -> MXHTTPOperation? {
		let apiUrl: String? = session.homeserverWellknown.integrations?.managers.first?.apiUrl
		var client: MXHTTPClient? = MXHTTPClient(baseURL: apiUrl, andOnUnrecognizedCertificateBlock: nil)
		let path: String = "account?v=1.1&scalar_token=\(scalarToken)"

		let userId: String = session.myUser.userId

		return client?.request(
			withMethod: "GET",
			path: path,
			parameters: nil) { jsonResponse in
				client = nil
				guard (jsonResponse?["user_id"] as? String) == userId else { completion(.success(false)); return }
				completion(.success(true))
			} failure: { error in
				client = nil
				guard let urlResponse = MXHTTPOperation.urlResponse(fromError: error),
					  urlResponse.statusCode / 100 != 2
				else { completion(.failure); return }
				completion(.success(false))
			}
	}
}
