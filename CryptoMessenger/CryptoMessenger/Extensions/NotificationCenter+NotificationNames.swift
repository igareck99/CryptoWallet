import Foundation

extension Notification.Name {
	static let userDidLoggedOut = Notification.Name("UserDidLoggedOut")
	static let userDidLoggedIn = Notification.Name("UserDidLoggedIn")
	static let userDidRegistered = Notification.Name("UserDidRegistered")
    static let configDidUpdate = Notification.Name("ConfigDidUpdate")

	static let statusBarTapped = Notification.Name("StatusBarTappedNotification")

	static let callViewWillAppear = Notification.Name("CallViewWillAppear")
	static let callViewDidAppear = Notification.Name("CallViewDidAppear")
	static let callViewDidDisappear = Notification.Name("CallViewDidDisappear")

	static let callDidStart = Notification.Name("CallDidStart")
	static let callDidEnd = Notification.Name("CallDidEnd")
    
    static let photoAccessLevelDidChange = Notification.Name("PhotoAccessLevelDidChange")
    static let locationAccessLevelDidChange = Notification.Name("LocationAccessLevelDidChange")
    
    static let didRefreshToken = Notification.Name("SessionTokensDidRefresh")
    static let didFailRefreshToken = Notification.Name("SessionTokensDidNotRefresh")
    static let didExpireMatrixSessionToken = Notification.Name("MatrixSessionTokensDidExpire")
}
