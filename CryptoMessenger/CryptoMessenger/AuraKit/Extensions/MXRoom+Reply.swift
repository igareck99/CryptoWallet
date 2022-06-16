import Foundation
import MatrixSDK

// swiftlint:disable all
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

		sendReply(
			to: eventToReply,
			withTextMessage: textMessage,
			formattedTextMessage: formattedTextMessage,
			stringLocalizations: stringLocalizations,
			localEcho: &localEcho,
			customParameters: customParameters,
			success: aura_currySuccess(completion),
			failure: aura_curryFailure(completion)
		)
	}
}

private extension MXRoom {
	/**
	 Return a closure that accepts any object, converts it to a MXResponse value, and then
	 executes the provided completion block

	 The `transform` parameter is helpful in cases where `T` and `U` are different types,
	 for instance when `U` is an enum, and `T` is it's identifier as a String.

	 - parameters:
	 - transform: A block that takes the output from the API and transforms it to the expected
	 type. The default block returns the input as-is.
	 - input: The value taken directly from the API call.
	 - completion: A block that gets called with the manufactured `MXResponse` variable.
	 - response: The API response wrapped in a `MXResponse` enum.

	 - returns: a block that accepts an optional value from the API, wraps it in an `MXResponse`, and then passes it to `completion`


	 ## Usage Example:

	 ```
	 func guestAccess(forRoom roomId: String, completion: @escaping (_ response: MXResponse<MXRoomGuestAccess>) -> Void) -> MXHTTPOperation? {
	 return __guestAccess(ofRoom: roomId, success: success(transform: MXRoomGuestAccess.init, completion), failure: error(completion))
	 }
	 ```

	 1. The `success:` block of the `__guestAccess` function passes in a `String?` type from the API.
	 2. That value gets fed into the `transform:` block – in this case, an initializer for `MXRoomGuestAccess`.
	 3. The `MXRoomGuestAccess` value returned from the  `transform:` block is wrapped in a `MXResponse` enum.
	 4. The newly created `MXResponse` is passed to the completion block.

	 */
	func aura_currySuccess<T, U>(
		transform: @escaping (_ input: T) -> U? = { return $0 as? U },
		_ completion: @escaping (_ response: MXResponse<U>) -> Void
	) -> (T) -> Void {
		return { completion(.aura_fromOptional(value: transform($0))) }
	}

	/// Special case of currySuccess for Objective-C functions whose competion handlers take no arguments
	func aura_currySuccess(_ completion: @escaping (_ response: MXResponse<Void>) -> Void) -> () -> Void {
		return { completion(MXResponse.success(Void())) }
	}

	/// Return a closure that accepts any error, converts it to a MXResponse value, and then executes the provded completion block
	func aura_curryFailure<T>(_ completion: @escaping (MXResponse<T>) -> Void) -> (Error?) -> Void {
		return { completion(.aura_fromOptional(error: $0)) }
	}
}

private extension MXResponse {

	/**
	 Take the value from an optional, if it's available.
	 Otherwise, return a failure with _MXUnknownError

	 - parameter value: to be captured in a `.success` case, if it's not `nil` and the type is correct.

	 - returns: `.success(value)` if the value is not `nil`, otherwise `.failure(_MXUnkownError())`
	 */
	static func aura_fromOptional(value: Any?) -> MXResponse<T> {
		if let value = value as? T {
			return .success(value)
		} else {
			return .failure(Aura_MXUnknownError())
		}
	}

	/**
	 Take the error from an optional, if it's available.
	 Otherwise, return a failure with _MXUnknownError

	 - parameter error: to be captured in a `.failure` case, if it's not `nil`.

	 - returns: `.failure(error)` if the value is not `nil`, otherwise `.failure(_MXUnkownError())`
	 */
	static func aura_fromOptional(error: Error?) -> MXResponse<T> {
		return .failure(error ?? Aura_MXUnknownError())
	}
}

/**
 Represents an error that was unexpectedly nil.

 This struct only exists to fill in the gaps formed by optionals that
 were created by ObjC headers that don't specify nullibility. Under
 normal controlled circumstances, this should probably never be used.
 */
struct Aura_MXUnknownError : Error {
	var localizedDescription: String {
		return "error object was unexpectedly nil"
	}
}
