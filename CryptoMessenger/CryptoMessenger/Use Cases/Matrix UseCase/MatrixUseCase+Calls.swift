import Foundation
import MatrixSDK

extension MatrixUseCase {
    func getCallIn(roomId: String) -> MXCall? {
        let room = getRoomInfo(roomId: roomId)
        let call = room?.mxSession.callManager.call(inRoom: roomId)
        return call
    }
}
