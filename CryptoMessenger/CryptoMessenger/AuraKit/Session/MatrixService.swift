import Combine
import Foundation
import SwiftUI
import MatrixSDK
import MatrixSDKCrypto
import JitsiMeetSDK

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
    case sendCryptoError
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
    var currentOperation: MXHTTPOperation?

	@Published var loginState: MatrixState = .none
	var loginStatePublisher: Published<MatrixState>.Publisher { $loginState }
	@Published var devices = [MXDevice]()
	var devicesPublisher: Published<[MXDevice]>.Publisher { $devices }
    @Published var currentRoomState = MXRoomState()
    var roomStatePublisher: Published<MXRoomState>.Publisher { $currentRoomState }

	var roomListDataFetcher: MXRoomListDataFetcher?
	var rooms: [MXRoom]? { session?.rooms }
	var client: MXRestClient?
	var credentials: MXCredentials? { client?.credentials }
	var listenReference: Any? // MXSessionEventListener
	var listenReferenceRoom: Any?
	let keychainService: KeychainServiceProtocol
	let userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage
	private(set) var session: MXSession?
	private(set) var fileStore: MXFileStore
	private(set) var uploader: MXMediaLoader?
    let config: ConfigType
    static let shared = MatrixService()

	init(
		client: MXRestClient? = nil,
		session: MXSession? = nil,
		fileStore: MXFileStore = MXFileStore(),
		uploader: MXMediaLoader? = nil,
        config: ConfigType = Configuration.shared,
		keychainService: KeychainServiceProtocol = KeychainService.shared,
		userSettings: UserDefaultsServiceProtocol & UserCredentialsStorage = UserDefaultsService.shared
	) {
		self.client = client
		self.session = session
		self.fileStore = fileStore
		self.uploader = uploader
        self.config = config
		self.keychainService = keychainService
		self.userSettings = userSettings
		configureMatrixSDKSettings()
	}

	deinit {
		session?.removeListener(listenReference)
	}

	private func getCedentials() -> MXCredentials? {
		guard
			let homeServer: String = keychainService.homeServer,
            let userId: String = userSettings.userId,
			let accessToken: String = keychainService.accessToken,
			let deviceId: String = keychainService.deviceId
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
}
