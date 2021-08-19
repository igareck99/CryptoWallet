//
//  CallListConfigurator.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 19.08.2021
//  
//

import Foundation

// MARK: - CallListConfigurator

enum CallListConfigurator {
    static func configuredViewController(delegate: CallListSceneDelegate?) -> CallListViewController {

        // MARK: - Internal Methods

        let viewController = CallListViewController()
        let presenter = CallListPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
