import SwiftUI

protocol OnboardingSceneDelegate: AnyObject {
    func onFinishOnboarding()
}

// MARK: - OnboardingViewModelDelegate

protocol OnboardingViewModelDelegate: ObservableObject {

    func handleContinueButtonTap()

    var screens: [OboardingPageData] { get }

    var continueText: String { get }
    
    var resources: OnboardingResourcable.Type { get }
}

// MARK: - OnboardingViewModel

final class OnboardingViewModel: ObservableObject, OnboardingViewModelDelegate {

    // MARK: - Internal Properties

    var delegate: OnboardingSceneDelegate?
    let resources: OnboardingResourcable.Type
    let screens: [OboardingPageData] = OboardingPageData.allCases
    var continueText = ""

    // MARK: - Private Properties

    private let userFlows: UserFlowsStorage

    // MARK: - Lifecycle

    init(
        delegate: OnboardingSceneDelegate? = nil,
        resources: OnboardingResourcable.Type = OnboardingResources.self,
        userFlows: UserFlowsStorage
    ) {
        self.delegate = delegate
        self.resources = resources
        self.userFlows = userFlows
        updateData()
    }

    // MARK: - Internal Methods

    func handleContinueButtonTap() {
        userFlows.isOnboardingFlowFinished = true
        delegate?.onFinishOnboarding()
    }

    // MARK: - Private Methods

    private func updateData() {
        continueText = resources.continueText
    }
}
