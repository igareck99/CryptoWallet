import Foundation
import MatrixSDK

// swiftlint: disable all

enum MXRoomReplyError: Error {
    case unknownError
}

extension MXRoom {
	@nonobjc
	@discardableResult
	func sendReply(
		to eventToReply: MXEvent,
		textMessage: String,
		formattedTextMessage: String?,
		stringLocalizations: MXSendReplyEventStringLocalizerProtocol?,
		localEcho: inout MXEvent?,
		customParameters: [String: Any]?,
		completion: @escaping (_ response: MXResponse<String?>) -> Void
	) -> MXHTTPOperation? {

        self.sendReply(
            to: eventToReply,
            withTextMessage: textMessage,
            formattedTextMessage: formattedTextMessage,
            stringLocalizations: stringLocalizations,
            localEcho: &localEcho,
            customParameters: customParameters) { response in
                if let result = response {
                    completion(.success(result))
                    return
                }   
                completion(.failure(MXRoomReplyError.unknownError))
            }
        return nil
	}
}
