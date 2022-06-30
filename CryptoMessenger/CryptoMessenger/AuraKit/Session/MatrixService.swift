import Combine
import Foundation
import MatrixSDK
import SwiftUI

// swiftlint: disable: all

enum MXErrors: Error {
	case loginFailure
	case startSessionFailure
	case userIdRetrieve
	case voiceCallPlaceError
    case imageUploadError
    case fileUploadError
    case contactUploadError
	case unknown
	@available(*, deprecated, message: "Добавлено только для обратной совместимости")
	case syncFailure
}

enum MatrixState {
	case loggedOut
	case authenticating
	case failure(MXErrors)
	case loggedIn(userId: String)
}

final class MatrixService: MatrixServiceProtocol {

	var objectChangePublisher = ObservableObjectPublisher()

	@Published var loginState: MatrixState = .loggedOut
	var loginStatePublisher: Published<MatrixState>.Publisher { $loginState }
	@Published var devices = [MXDevice]()
	var devicesPublisher: Published<[MXDevice]>.Publisher { $devices }

	var rooms: [AuraRoom] {
		let rooms = session?.rooms
			.map { makeRoom(from: $0) }
			.sorted { $0.summary.lastMessageDate > $1.summary.lastMessageDate } ?? []
		return rooms
	}

	var client: MXRestClient?
	var credentials: MXCredentials?
	var listenReference: Any? // MXSessionEventListener
	var listenReferenceRoom: Any?

	let keychainService: KeychainServiceProtocol
	let userSettings: UserDefaultsServiceProtocol

	private(set) var session: MXSession?
	private(set) var fileStore: MXFileStore
	private(set) var uploader: MXMediaLoader?
	private(set) var roomCache = [ObjectIdentifier: AuraRoom]()

	let deviceRemovalGroup = DispatchGroup()

	static let shared = MatrixService()

	init(
		client: MXRestClient? = nil,
		session: MXSession? = nil,
		fileStore: MXFileStore = MXFileStore(),
		uploader: MXMediaLoader? = nil,
		credentials: MXCredentials? = nil,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		userSettings: UserDefaultsServiceProtocol = UserDefaultsService.shared
	) {
		self.client = client
		self.session = session
		self.fileStore = fileStore
		self.uploader = uploader
		self.credentials = credentials
		self.keychainService = keychainService
		self.userSettings = userSettings
		configureMatrixSDKSettings()
	}

	deinit {
		session?.removeListener(listenReference)
	}

	private func getCedentials() -> MXCredentials? {
		guard
			let homeServer: String = keychainService[.homeServer],
			let userId: String = keychainService[.userId],
			let accessToken: String = keychainService[.accessToken],
			let deviceId: String = keychainService[.deviceId]
		else {
			return nil
		}
		let credentials = MXCredentials(
			homeServer: homeServer,
			userId: userId,
			accessToken: accessToken
		)
		credentials.deviceId = deviceId
		return credentials
	}

	private func configureMatrixSDKSettings() {
		let sdkOptions = MXSDKOptions.sharedInstance()
		// sdkOptions.applicationGroupIdentifier = ""
		// Enable e2e encryption for newly created MXSession
		sdkOptions.enableCryptoWhenStartingMXSession = true
		sdkOptions.computeE2ERoomSummaryTrust = true
		// Use UIKit BackgroundTask for handling background tasks in the SDK
		// sdkOptions.backgroundModeHandler = MXUIKitBackgroundModeHandler()
	}

	private func makeRoom(from mxRoom: MXRoom) -> AuraRoom {
		let room = AuraRoom(mxRoom)
		if mxRoom.isDirect {
			room.isOnline = currentlyActive(mxRoom.directUserId)
		}
		roomCache[mxRoom.id] = room
		return room
	}
}

// MARK: - Updaters

extension MatrixService {

	func updateUnkownDeviceWarn(isEnabled: Bool) {
		session?.crypto.warnOnUnknowDevices = isEnabled
	}

	func updateClient(with homeServer: URL) {
		client = MXRestClient(homeServer: homeServer, unrecognizedCertificateHandler: nil)
	}

	func updateState(with state: MatrixState) {
		loginState = state
	}

	func updateUser(credentials: MXCredentials) {
		self.credentials = credentials
	}

	func updateService(credentials: MXCredentials) {

		let persistentTokenDataHandler: MXRestClientPersistTokenDataHandler =
		{ inputCredentialsHandler in
			debugPrint("upadteService MXRestClientPersistTokenDataHandler: inputCredentialsHandler: \(inputCredentialsHandler)")
			inputCredentialsHandler?([]) { didUpdateCredentials in
				debugPrint("upadteService MXRestClientPersistTokenDataHandler: inputCredentialsHandler didUpdateCredentials: \(didUpdateCredentials)")
			}
		}

		let andUnauthenticatedHandler: MXRestClientUnauthenticatedHandler =
		{ error, isSoftLogout, isRefreshTokenAuth, logoutCompletion in
			debugPrint("upadteService MXRestClientUnauthenticatedHandler: error: \(error)")
			debugPrint("upadteService MXRestClientUnauthenticatedHandler: isSoftLogout: \(isSoftLogout)")
			debugPrint("upadteService MXRestClientUnauthenticatedHandler: isRefreshTokenAuth: \(isRefreshTokenAuth)")
			debugPrint("upadteService MXRestClientUnauthenticatedHandler: logoutCompletion: \(logoutCompletion)")
			logoutCompletion?()
		}

		let client = MXRestClient(
			credentials: credentials,
			persistentTokenDataHandler: persistentTokenDataHandler,
			unauthenticatedHandler: andUnauthenticatedHandler
		)
		// MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)
		let session = MXSession(matrixRestClient: client)
		let callStack: MXCallStack = MXJingleCallStack()
		session?.enableVoIP(with: callStack)
		self.client = client
		self.session = session
		self.fileStore = MXFileStore()
		self.uploader = MXMediaLoader(forUploadWithMatrixSession: session, initialRange: 0, andRange: 1)
		configureCallKitAdapter()
	}

	private func configureCallKitAdapter() {
		let config = MXCallKitConfiguration()
		config.iconName = "AppIcon"
		config.name = "CryptoMessenger"
		let adapter = MXCallKitAdapter(configuration: config)
		let audioSessionConfigurator: MXCallAudioSessionConfigurator = MXJingleCallAudioSessionConfigurator()
		adapter.audioSessionConfigurator = audioSessionConfigurator
		session?.callManager.callKitAdapter = adapter
	}

	// MARK: - Pagination

	func paginate(room: AuraRoom, event: MXEvent) {
		let timeline = room.room.timeline(onEvent: event.eventId)
		listenReferenceRoom = timeline?.listenToEvents { event, direction, roomState in
			if direction == .backwards {
				room.add(event: event, direction: direction, roomState: roomState)
			}
			self.objectChangePublisher.send()
		}
		timeline?.resetPaginationAroundInitialEvent(withLimit: 1000) { _ in
			self.objectChangePublisher.send()
		}
	}

	// MARK: - Pusher

	func deletePusher(with pushToken: Data, completion: @escaping (Bool) -> Void) {
		updatePusher(pushToken: pushToken, kind: .none, completion: completion)
	}

	func createPusher(with pushToken: Data, completion: @escaping (Bool) -> Void) {
		updatePusher(pushToken: pushToken, kind: .http, completion: completion)
	}

	private func updatePusher(pushToken: Data, kind: MXPusherKind, completion: @escaping (Bool) -> Void) {

		guard !AppConstants.bundleId.aboutApp.isEmpty,
			  let userId = session?.myUser.userId else { return }

#if DEBUG
		let pushKeyRelease = pushToken.base64EncodedString()
		let pushKeyDebug = pushToken.map { String(format: "%02x", $0) }.joined()
		debugPrint("pushKeyRelease: \(pushKeyRelease.debugDescription)")
		debugPrint("pushKeyDebug: \(pushKeyDebug.debugDescription)")

		let pushKey = pushToken.map { String(format: "%02x", $0) }.joined()
#else
		let pushKey = pushToken.base64EncodedString()
#endif

		let pushData: [String: Any] = ["url": AppConstants.pusherUrl.aboutApp]
		let appId = AppConstants.bundleId.aboutApp
		let appDisplayName = AppConstants.appName.aboutApp
		let deviceDisplayName = UIDevice.current.name
		let lang = NSLocale.preferredLanguages.first ?? "en_US"
		let profileTag = "mobile_ios_\(userId)"

		client?.setPusher(
			pushKey: pushKey,
			kind: kind,
			appId: appId,
			appDisplayName: appDisplayName,
			deviceDisplayName: deviceDisplayName,
			profileTag: profileTag,
			lang: lang,
			data: pushData,
			append: false
		) { result in
			completion(result.isSuccess)
		}
	}
}