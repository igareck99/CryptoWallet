import UserNotifications
import MatrixSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var testBody: String = ""
    let keychainService = KeychainService.shared
    let userDefaultsService = UserDefaultsService.shared
    let config: ConfigType = Configuration.shared
    
    var matrixSession: MXSession?
    static var backgroundSyncService: MXBackgroundSyncService?
    let pushGateWayClient = MXPushGatewayRestClient(pushGateway: "https://matrix.aura.ms/")
    
    // MARK: - Internal Properties

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        // TODO: - Если нет доступа к чему-то, то возвращаем исходный контент
        let userInfo = request.content.userInfo
        self.contentHandler = contentHandler
        guard let roomId = userInfo["room_id"] as? String,
              let eventId = userInfo["event_id"] as? String else {
            //  it's not a Matrix notification, do not change the content
            contentHandler(request.content)
            return
        }
        guard let content = request.content.mutableCopy() as? UNMutableNotificationContent else {
            contentHandler(request.content)
            return
        }

        guard let session = updateService() else {
            contentHandler(content)
            return
        }
        matrixSession = session
        let store = MXFileStore()
        matrixSession?.setStore(store) { [weak self] response in
            guard response.isSuccess else {
                contentHandler(content)
                return
            }

            self?.matrixSession?.start { response in
                guard response.isSuccess else {
                    contentHandler(content)
                    return
                }
                guard let room = session.rooms.first(where: { $0.roomId == roomId }) else {
                    contentHandler(content)
                    return
                }

                let auraRoom = AuraRoom(room)
                guard let event = auraRoom.events().renderableEvents.first(where: { $0.eventId == eventId }) else {
                    contentHandler(content)
                    return
                }

                guard let body = self?.getMessageBody(event) else {
                    contentHandler(content)
                    return
                }

                content.body = body
                contentHandler(content)
                return
            }
        }
    }

    private func updateService() -> MXSession? {
        guard let credentials = getCredentials() else { return nil }
        let mxRestClient = MXRestClient(
            credentials: credentials,
            unrecognizedCertificateHandler: nil
        )
        let mxSession = MXSession(
            matrixRestClient: mxRestClient
        )
        Self.backgroundSyncService = MXBackgroundSyncService(withCredentials: credentials)
        return mxSession
    }

    private func getCredentials() -> MXCredentials? {
        guard let userId: String = userDefaultsService.userId,
              let accessToken: String = keychainService.accessToken,
              let homeServer: String = keychainService.homeServer,
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

    private func getMessageBody(_ event: MXEvent) -> String? {
        debugPrint("NotificationsUseCase getMessageBody: \(event)")
        let sender = event.sender ?? ""
        switch event.messageType {
        case .text(_):
            return "Пользователь \(sender) отправил вам текстовое сообщение"
        case .audio(_):
            return "Пользователь \(sender) отправил вам голосовое сообщение"
        case .video(_):
            return "Пользователь \(sender) отправил вам видео"
        case .file(_, _):
            return "Пользователь \(sender) отправил вам файл"
        case .image(_):
            return "Пользователь \(sender) отправил вам фото"
        case .contact(
            name: event.content["name"] as? String ?? "",
            phone: event.content["phone"] as? String ?? "",
            url: event.content["url"] as? URL
        ):
            return "Пользователь \(sender) отправил вам контакт"
        case .location(_):
            return "Пользователь \(sender) отправил вам геолокацию"
        case .call:
            handleCallPush(event: event)
            return "Вам звонит \(sender)"
        default:
            handleCallPush(event: event)
            return "Вам звонит \(sender)"
        }
    }

    override func serviceExtensionTimeWillExpire() {
        guard let contentHandler = contentHandler,
              let bestAttemptContent = bestAttemptContent else { return }
        contentHandler(bestAttemptContent)
    }
}

private extension NotificationService {

    func handleCallPush(event: MXEvent) {
        guard event.eventType == .callInvite else { return }
        debugPrint("NotificationsUseCase handleCallPush: \(event)")
        Self.backgroundSyncService?.event(
            withEventId: event.eventId,
            inRoom: event.roomId,
            completion: { [weak self] response in
                guard case let .success(event) = response else { return }
                self?.processEvent(event)
            })
    }

    func processEvent(_ event: MXEvent) {
        Self.backgroundSyncService?.readMarkerEvent(
            forRoomId: event.roomId
        ) { [weak self] response in
            guard case let .success(readEvent) = response else {
                return
            }
            self?.matrixSession?.callManager.handleCall(readEvent)
            let eventContent = MXCallEventContent(fromJSON: readEvent.content)
            let callID = eventContent?.callId ?? ""
            debugPrint("NotificationsUseCase readMarkerEvent \(callID)")
            guard let call = self?.matrixSession?.callManager.call(withCallId: callID) else {
                return
            }
            debugPrint("NotificationsUseCase readMarkerEvent \(call)")
            self?.matrixSession?.callManager.callKitAdapter?.reportIncomingCall(call)
            self?.sendVoipPush(event: event)
        }
    }

    func sendVoipPush(
        event: MXEvent,
        sender: String = "NotificationService sender"
    ) {
        guard
            let pushVoipToken: Data = self.keychainService.data(forKey: .pushVoipToken)
        else {
            return
        }
        
        debugPrint("NotificationsUseCase sendVoipPush")
        
        self.pushGateWayClient.notifyApp(
            withId: config.voipPushesPusherId,
            pushToken: pushVoipToken,
            eventId: event.eventId,
            roomId: event.roomId,
            eventType: event.wireType,
            sender: sender,
            timeout: 30) { result in
                debugPrint("NotificationsUseCase pushGateWayClient.notifyApp SUCCESS result:\(result)")
            } failure: { error in
                debugPrint("NotificationsUseCase pushGateWayClient.notifyApp FAILURE result:\(error)")
            }
    }
}
