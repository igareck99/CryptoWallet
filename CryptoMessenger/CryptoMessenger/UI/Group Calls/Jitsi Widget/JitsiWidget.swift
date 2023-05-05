import Foundation
import MatrixSDK

@objcMembers
final class JitsiWidget: NSObject {

	 // The widget type
	 // Some types are defined in `WidgetManager.h`
	 // Nil if the widget is no more active in the room
	let type: String?

	 // The raw widget url
	 // This is the preformated version of the widget url containing parameters names
	 // This is not a valid url. The url to use in a webview can be obtained with `[self widgetUrl:]`
	let url: String?

	// The widget name
	let name: String?

	// The widget additional data
	let data: [String: Any]?

	// The widget event that is at the origin of the widget
	let event: MXEvent

	// The Matrix session where the widget is.
	let session: MXSession

	// The widget id
	var widgetId: String {
		event.stateKey
	}

	// Indicate if the widget is still active
	var isActive: Bool {
		type != nil && url != nil
	}

	// The room id of the widget
	var roomId: String {
		event.roomId
	}

	// Create a AURWidget instance from a widget event.
	init?(event: MXEvent, session: MXSession) {
		// TODO - Room widgets need to be moved to 'm.widget' state events
		// https://docs.google.com/document/d/1uPF7XWY_dXTKVKV7jZQ2KmsI19wn9-kFRgQ1tFQP7wQ/edit?usp=sharing
		// The Widget class works only with modular, aka "m.widget" or "im.vector.modular.widgets", widgets
		guard event.type == JistsiConstants.kWidgetMatrixEventTypeString ||
				event.type == JistsiConstants.kWidgetModularEventTypeString else { return nil }

		self.event = event
		self.session = session
		self.type = event.content["type"] as? String
		self.url = event.content["url"] as? String
		self.name = event.content["name"] as? String
		self.data = event.content["data"] as? [String: Any]
	}
}
