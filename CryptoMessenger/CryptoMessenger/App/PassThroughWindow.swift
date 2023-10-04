import UIKit

final class PassThroughWindow: UIWindow {

    weak var navController: UINavigationController?
    private let p2pCallUseCase: P2PCallUseCase
    private let statusBarUseCase: StatusBarCallUseCase

    init(
        windowScene: UIWindowScene,
        p2pCallUseCase: P2PCallUseCase = P2PCallUseCase.shared,
        statusBarUseCase: StatusBarCallUseCase = StatusBarCallUseCase.shared
    ) {
        self.p2pCallUseCase = p2pCallUseCase
        self.statusBarUseCase = statusBarUseCase
        super.init(windowScene: windowScene)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        let noControllers = (navController?.viewControllers.count ?? .zero) == 1

        if p2pCallUseCase.isActiveCallExist &&
            statusBarUseCase.aboveStatusViewRect.contains(point) {
            return hitView
        }

        return noControllers ? nil : hitView
    }
}
