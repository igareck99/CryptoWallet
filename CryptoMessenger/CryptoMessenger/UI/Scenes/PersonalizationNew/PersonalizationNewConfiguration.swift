import Foundation

// MARK: - PersonalizationNewConfigurator

enum PersonalizationNewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationNewSceneDelegate?) -> PersonalizationNewView {
        let viewModel = PersonalizationNewViewModel()
        viewModel.delegate = delegate
        let view = PersonalizationNewView(viewModel: viewModel)
        return view
    }
}

// MARK: - LanguageNewViewConfigurator

enum LanguageNewViewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationNewSceneDelegate?) -> LanguageNewView {
        let viewModel = PersonalizationNewViewModel()
        viewModel.delegate = delegate
        let view = LanguageNewView(viewModel: viewModel)
        return view
    }
}

// MARK: - TypographyNewViewConfigurator

enum TypographyNewViewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationNewSceneDelegate?) -> TypographyNewView {
        let viewModel = PersonalizationNewViewModel()
        viewModel.delegate = delegate
        let view = TypographyNewView(viewModel: viewModel)
        return view
    }
}

// MARK: - SelectBackgroundConfigurator

enum SelectBackgroundConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationNewSceneDelegate?) -> SelectBackgroundView {
        let viewModel = PersonalizationNewViewModel()
        viewModel.delegate = delegate
        let view = SelectBackgroundView(viewModel: viewModel)
        return view
    }
}

// MARK: - ProfileBackgroundNewViewConfigurator

enum ProfileBackgroundNewViewConfigurator {

    // MARK: - Static Methods

    static func configuredView(delegate: PersonalizationNewSceneDelegate?) -> ProfileBackgroundNewView {
        let viewModel = PersonalizationNewViewModel()
        viewModel.delegate = delegate
        let view = ProfileBackgroundNewView(personalizationViewModel: viewModel)
        return view
    }
}
