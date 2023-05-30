import SwiftUI

// MARK: - RemoteConfigUseCaseAssembly

enum OnboardingAssembly {

    // MARK: - Static Methods

    static func build(delegate: OnboardingSceneDelegate?) -> some View {
        let userFlows = UserDefaultsService.shared
        let sources = OnboardingResources.self
        let viewModel = OnboardingViewModel(delegate: delegate,
                                            sources: sources,
                                            userFlows: userFlows)
        viewModel.delegate = delegate
        let view = OnboardingView(
            viewModel: viewModel
        )
        return view
    }
}
