import MatrixSDK

extension MatrixService {
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
    
    func updatePusher(
        appId: String,
        pushToken: Data,
        kind: MXPusherKind = .http,
        completion: @escaping (Bool) -> Void
    ) {
        guard let userId = client?.credentials.userId else {
            completion(false)
            return
        }
        
        let pushKey = pushToken.base64EncodedString()
        // MARK: - оставил для тестирования
        //        let token = pushToken.map { String(format: "%02.2hhx", $0) }.joined()
        
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
