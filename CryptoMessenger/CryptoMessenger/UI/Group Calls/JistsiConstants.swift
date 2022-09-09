import Foundation

// TODO: Вернуть обратно в enum
@objcMembers
final class JistsiConstants: NSObject {

	// The type of matrix event used for matrix widgets.
	static let kWidgetMatrixEventTypeString = "m.widget"

	// The type of matrix event used for modular widgets.
	// TODO: It should be replaced by kWidgetMatrixEventTypeString.
	static let kWidgetModularEventTypeString = "im.vector.modular.widgets"

	// Known types widgets
	static let kWidgetTypeJitsiV1 = "jitsi"
	static let kWidgetTypeJitsiV2 = "m.jitsi"
	static let kWidgetTypeStickerPicker = "m.stickerpicker"

	// Тип авторизации openJWT
	static let openIDTokenJWT = "openidtoken-jwt"

	// Posted when a widget has been created, updated or disabled.
	// The notification object is the `Widget` instance.
	static let kWidgetManagerDidUpdateWidgetNotification = "kWidgetManagerDidUpdateWidgetNotification"
}
