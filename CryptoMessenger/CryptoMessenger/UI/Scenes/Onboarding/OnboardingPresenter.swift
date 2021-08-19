import UIKit

// MARK: - OnboardingPresenter

final class OnboardingPresenter {

    // MARK: - OnboardingPage

    struct OnboardingPage {
        let title: String
        let image: UIImage?
    }

    // MARK: - Internal Properties

    weak var delegate: OnboardingSceneDelegate?
    weak var view: OnboardingViewInterface?

    // MARK: - Private Properties

    @Injectable private var userFlows: UserFlowsStorageService

    // MARK: - Lifecycle

    init(view: OnboardingViewInterface) {
        self.view = view
    }
}

// MARK: - OnboardingPresenter (OnboardingPresentation)

extension OnboardingPresenter: OnboardingPresentation {
    var pages: [OnboardingPage] {
        [
            .init(
                title: R.string.localizable.onboardingPage1(),
                image: R.image.onboarding.page1()
            ),
            .init(
                title: R.string.localizable.onboardingPage2(),
                image: R.image.onboarding.page2()
            ),
            .init(
                title: R.string.localizable.onboardingPage3(),
                image: R.image.onboarding.page3()
            )
        ]
    }

    func handleContinueButtonTap() {
        userFlows.isOnboardingFlowFinished = true
        delegate?.handleNextScene(.registration)
    }
}