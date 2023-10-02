import Foundation

extension MatrixUseCase {
    func makeWidget(event: MXEvent) -> JitsiWidget? {
        guard let session = matrixSession else { return nil }
        let widget = jitsiFactory.makeWidget(event: event, session: session)
        return widget
    }
}
