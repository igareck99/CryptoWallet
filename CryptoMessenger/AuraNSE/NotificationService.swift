import UserNotifications
import MatrixSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var testBody: String = ""
    let keychainService = KeychainService.shared
    
    // MARK: - Internal Properties
    
    override init() {
        super.init()
    }

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        debugPrint("NotificationService didReceive")
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
            contentHandler(request.content)
            return
        }
        let store = MXFileStore()
        session.setStore(store) { response in
            guard response.isSuccess else { return }
            session.start { response in
                guard response.isSuccess else { return }
                guard let room = session.rooms.first(where: { $0.roomId == roomId }) else {
                    contentHandler(request.content)
                    return
                }
                let auraRoom = AuraRoom(room)
                guard let event = auraRoom.events().renderableEvents.first(where: { $0.eventId == eventId }) else {
                    contentHandler(request.content)
                    return
                }
                guard let body = self.getMessageBody(event) else {
                    contentHandler(request.content)
                    return
                }
                content.body = body
                contentHandler(content)
                return
            }
        }
    }

    private func updateService() -> MXSession? {
        debugPrint("NotificationService updateService")

        guard let userId: String = keychainService[.userId],
              let accessToken: String = keychainService[.accessToken],
              let homeServer: String = keychainService[.homeServer],
              let deviceId: String = keychainService[.deviceId]  else {
            return nil
        }

        let credentials = MXCredentials(homeServer: homeServer,
                                        userId: userId,
                                        accessToken: accessToken)
        credentials.deviceId = deviceId
        let mxRestClient = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)
        let mxSession = MXSession(matrixRestClient: mxRestClient)
        return mxSession
    }

    private func getMessageBody(_ event: MXEvent) -> String? {
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
        case .contact(name: event.content["name"] as? String ?? "",
                      event.content["phone"] as? String ?? "",
                      url: event.content["url"] as? URL):
            return "Пользователь \(sender) отправил вам контакт"
        case .location(_):
            return "Пользователь \(sender) отправил вам геолокацию"
        default:
            return nil
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        debugPrint("NotificationService serviceExtensionTimeWillExpire")
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
