import Foundation

protocol JitsiWidgetFactoryProtocol {
    static func makeWidget(event: MXEvent, session: MXSession) -> JitsiWidget?
}

enum JitsiWidgetFactory: JitsiWidgetFactoryProtocol {
    static func makeWidget(event: MXEvent, session: MXSession) -> JitsiWidget? {
        let widget = JitsiWidget(event: event, session: session)
        return widget
    }
}
