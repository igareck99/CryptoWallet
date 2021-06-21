//
//  OnboardingConfigurator.swift
//  CryptoMessenger
//
//  Created by Dmitrii Ziablikov on 21.06.2021
//  
//

import Foundation

// MARK: OnboardingConfigurator

enum OnboardingConfigurator {
    static func configuredViewController(delegate: OnboardingSceneDelegate?) -> OnboardingViewController {

        // MARK: - Internal Methods

        let viewController = OnboardingViewController()
        let presenter = OnboardingPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
