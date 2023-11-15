import Combine
import Foundation
import SwiftUI
import JitsiMeetSDK
import MatrixSDK
import MatrixSDKCrypto

// swiftlint:disable all

enum MXErrors: Error {
	case loginFailure
	case startSessionFailure
	case userIdRetrieve
	case voiceCallPlaceError
	case videoCallPlaceError
    case imageUploadError
    case fileUploadError
    case audioUploadError
    case contactUploadError
    case videoUploadError
    case sendTextError
    case sendReplyError
    case sendGeoError
    case publicRoomError
    case encryptRoomError
    case removeReactionFailure
	case unknown
	@available(*, deprecated, message: "Добавлено только для обратной совместимости")
	case syncFailure
}


enum MatrixState {
	case none
	case loggedOut
	case authenticating
	case failure(MXErrors)
	case loggedIn(userId: String)
}

final class MatrixService: MatrixServiceProtocol {

	var objectChangePublisher = ObservableObjectPublisher()

	@Published var loginState: MatrixState = .none
	var loginStatePublisher: Published<MatrixState>.Publisher { $loginState }
	@Published var devices = [MXDevice]()
	var devicesPublisher: Published<[MXDevice]>.Publisher { $devices }

	private let matrixObjectsFactory: MatrixObjectFactoryProtocol
	var roomListDataFetcher: MXRoomListDataFetcher?
    var auraRooms: [AuraRoomData] {
        let rooms = matrixObjectsFactory
            .makeAuraRooms(mxRooms: session?.rooms,
                           isMakeEvents: true,
                                  config: Configuration.shared,
                                  eventsFactory: RoomEventObjectFactory(),
                                  matrixUseCase: MatrixUseCase.shared)
        return rooms
    }
    var auraNoEventsRooms: [AuraRoomData] {
        let rooms = matrixObjectsFactory
            .makeAuraRooms(mxRooms: session?.rooms,
                           isMakeEvents: false,
                                  config: Configuration.shared,
                                  eventsFactory: RoomEventObjectFactory(),
                                  matrixUseCase: MatrixUseCase.shared)
        return rooms
    }
	var rooms: [AuraRoom] {
		let rooms = matrixObjectsFactory
			.makeRooms(mxRooms: session?.rooms) { [weak self] directUserId in
				self?.currentlyActive(directUserId) == true
			}
		return rooms
	}

	var client: MXRestClient?
	var credentials: MXCredentials? {
		client?.credentials
	}
	var listenReference: Any? // MXSessionEventListener
	var listenReferenceRoom: Any?
	let keychainService: KeychainServiceProtocol
	let userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage
	private(set) var session: MXSession?
	private(set) var fileStore: MXFileStore
	private(set) var uploader: MXMediaLoader?
	private(set) var roomCache = [ObjectIdentifier: AuraRoom]()
	let deviceRemovalGroup = DispatchGroup()
	static let shared = MatrixService()
    private let config: ConfigType

	init(
		client: MXRestClient? = nil,
		session: MXSession? = nil,
		fileStore: MXFileStore = MXFileStore(),
		uploader: MXMediaLoader? = nil,
        config: ConfigType = Configuration.shared,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage = UserDefaultsService.shared,
		matrixObjectsFactory: MatrixObjectFactoryProtocol = MatrixObjectFactory()
	) {
		self.client = client
		self.session = session
		self.fileStore = fileStore
		self.uploader = uploader
        self.config = config
		self.keychainService = keychainService
		self.userSettings = userSettings
		self.matrixObjectsFactory = matrixObjectsFactory
		configureMatrixSDKSettings()
	}

	deinit {
		session?.removeListener(listenReference)
	}

	private func getCedentials() -> MXCredentials? {
		guard
			let homeServer: String = keychainService[.homeServer],
            let userId: String = userSettings.userId,
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
		sdkOptions.enableCryptoWhenStartingMXSession = false
		sdkOptions.computeE2ERoomSummaryTrust = true
		// Use UIKit BackgroundTask for handling background tasks in the SDK
		// sdkOptions.backgroundModeHandler = MXUIKitBackgroundModeHandler()
	}
}

// MARK: - Updaters

extension MatrixService {

	func closeSessionAndClearData() {
		fileStore.deleteAllData()
		session?.close()
	}

    func updateUnkownDeviceWarn(isEnabled: Bool) {
        guard let crypto = session?.crypto as? MXLegacyCrypto else { return }
		crypto.warnOnUnknowDevices = isEnabled
	}

	func updateClient(with homeServer: URL) {
		client = MXRestClient(homeServer: homeServer, unrecognizedCertificateHandler: nil)
	}

	func updateState(with state: MatrixState) {
		loginState = state
	}
    
    private func notifyTokenExpiration() {
        NotificationCenter
            .default
            .post(
                name: .didExpireMatrixSessionToken,
                object: nil
            )
    }

	func updateService(credentials: MXCredentials) {

		let persistTokenDataHandler: MXRestClientPersistTokenDataHandler = { inputCredentialsHandler in
            debugPrint("inputCredentialsHandler: \(String(describing: inputCredentialsHandler))")
			inputCredentialsHandler?([]) { didUpdateCredentials in
				debugPrint("didUpdateCredentials: \(didUpdateCredentials)")
			}
		}

		let unauthenticatedHandler: MXRestClientUnauthenticatedHandler = {
            [weak self] error, isSoftLogout, isRefreshTokenAuth, logoutCompletion in
            
            if String(describing: error).contains("M_UNKNOWN_TOKEN") {
                self?.notifyTokenExpiration()
            }
            
            debugPrint("error: \(String(describing: error))")
			debugPrint("isSoftLogout: \(isSoftLogout)")
			debugPrint("isRefreshTokenAuth: \(isRefreshTokenAuth)")
            debugPrint("logoutCompletion: \(String(describing: logoutCompletion))")
			logoutCompletion?()
		}

		let client = MXRestClient(
            credentials: credentials,
            persistentTokenDataHandler: persistTokenDataHandler,
            unauthenticatedHandler: unauthenticatedHandler
		)
		self.client = client

		let session = MXSession(matrixRestClient: client)
		let callStack: MXCallStack = MXJingleCallStack()
		session?.enableVoIP(with: callStack)
		self.session = session
        MXFileStore.setPreloadOptions([.roomAccountData, .roomState, .roomMessages])
		self.fileStore = MXFileStore(credentials: credentials)
        if let user = MXMyUser(userId: credentials.userId) {
            self.fileStore.store(user)
        }
		self.uploader = MXMediaLoader(forUploadWithMatrixSession: session, initialRange: 0, andRange: 1)
		configureCallKitAdapter()
	}

	private func configureCallKitAdapter() {
		let config = MXCallKitConfiguration()
		config.iconName = "AppIcon"
		config.name = "CryptoMessenger"

		JitsiService.configureCallKitProvider(
			localizedName: config.name,
			ringtoneName: config.ringtoneName
		)

		let adapter = MXCallKitAdapter(configuration: config)
		let audioSessionConfigurator: MXCallAudioSessionConfigurator = MXJingleCallAudioSessionConfigurator()
		audioSessionConfigurator.configureAudioSession(forVideoCall: true)
		adapter.audioSessionConfigurator = audioSessionConfigurator
		session?.callManager?.callKitAdapter = adapter
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

	func deletePusher(
        appId: String,
        pushToken: Data,
        completion: @escaping GenericBlock<Bool>
    ) {
		updatePusher(
            appId: appId,
            pushToken: pushToken,
            kind: .none,
            completion: completion
        )
	}

    func createPusher(pushToken: Data, completion: @escaping GenericBlock<Bool>) {
        updatePusher(
            appId: config.pushesPusherId,
            pushToken: pushToken,
            completion: completion
        )
	}

    func createVoipPusher(pushToken: Data, completion: @escaping GenericBlock<Bool>) {
        updatePusher(
            appId: config.voipPushesPusherId,
            pushToken: pushToken,
            completion: completion
        )
    }

	private func updatePusher(
        appId: String,
        pushToken: Data,
        kind: MXPusherKind = .http,
        completion: @escaping (Bool) -> Void
    ) {

        guard let userId = client?.credentials.userId else { completion(false); return }

        let pushKey = pushToken.base64EncodedString()
        
        let pushData: [String: Any] = [
            "url": config.pusherUrl,
            "format": "event_id_only",
            "default_payload": [
                "aps": [
                    "mutable-content": 1,
                    "apps-expiration": 0,
                    "alert": [
                        "loc-key": "Notification",
                        "loc-args": []
                    ]
                ]
            ]
        ]

		let lang = NSLocale.preferredLanguages.first ?? "en_US"
        let profileTag = "mobile_ios_\(userId.hashValue)"

		client?.setPusher(
			pushKey: pushKey,
			kind: kind,
			appId: appId,
			appDisplayName: config.appName,
			deviceDisplayName: config.deviceName,
			profileTag: profileTag,
			lang: lang,
			data: pushData,
			append: true
		) { result in
			completion(result.isSuccess)
		}
	}
}
