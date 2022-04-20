import Foundation

// MARK: - PersonalizationConfigurator

enum PersonalizationConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationSceneDelegate?) -> PersonalizationView {
		let userCredentials = UserDefaultsService.shared
        let viewModel = PersonalizationViewModel(userCredentials: userCredentials)
        viewModel.delegate = delegate
        let view = PersonalizationView(viewModel: viewModel)
        return view
    }
}

// MARK: - LanguageViewConfigurator

enum LanguageViewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationSceneDelegate?) -> LanguageView {
		let userCredentials = UserDefaultsService.shared
		let viewModel = PersonalizationViewModel(userCredentials: userCredentials)
        viewModel.delegate = delegate
        let view = LanguageView(viewModel: viewModel)
        return view
    }
}

// MARK: - TypographyViewConfigurator

enum TypographyViewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationSceneDelegate?) -> TypographyView {
		let userCredentials = UserDefaultsService.shared
		let viewModel = PersonalizationViewModel(userCredentials: userCredentials)
        viewModel.delegate = delegate
        let view = TypographyView(viewModel: viewModel)
        return view
    }
}

// MARK: - SelectBackgroundConfigurator

enum SelectBackgroundConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationSceneDelegate?) -> SelectBackgroundView {
		let userCredentials = UserDefaultsService.shared
		let viewModel = PersonalizationViewModel(userCredentials: userCredentials)
        viewModel.delegate = delegate
        let view = SelectBackgroundView(viewModel: viewModel)
        return view
    }
}

// MARK: - ProfileBackgroundViewConfigurator

enum ProfileBackgroundViewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationSceneDelegate?) -> ProfileBackgroundView {
		let userCredentials = UserDefaultsService.shared
		let viewModel = PersonalizationViewModel(userCredentials: userCredentials)
        viewModel.delegate = delegate
        let view = ProfileBackgroundView(personalizationViewModel: viewModel)
        return view
    }
}
