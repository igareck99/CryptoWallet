import Foundation

extension MatrixUseCase {
    func createPusher(pushToken: Data, completion: @escaping (Bool) -> Void) {
        matrixService.createPusher(pushToken: pushToken, completion: completion)
    }

    func deletePusher(appId: String, pushToken: Data, completion: @escaping (Bool) -> Void) {
        matrixService.deletePusher(appId: appId, pushToken: pushToken, completion: completion)
    }

    func createVoipPusher(pushToken: Data, completion: @escaping (Bool) -> Void) {
        matrixService.createVoipPusher(pushToken: pushToken, completion: completion)
    }
}
