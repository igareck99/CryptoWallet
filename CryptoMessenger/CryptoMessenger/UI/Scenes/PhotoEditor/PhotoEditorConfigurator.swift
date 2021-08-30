//
//  PhotoEditorConfigurator.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 30.08.2021
//  
//

import Foundation

// MARK: - PhotoEditorConfigurator

enum PhotoEditorConfigurator {
    static func configuredViewController(delegate: PhotoEditorSceneDelegate?) -> PhotoEditorViewController {

        // MARK: - Internal Methods

        let viewController = PhotoEditorViewController()
        let presenter = PhotoEditorPresenter(view: viewController)
        presenter.delegate = delegate
        viewController.presenter = presenter
        return viewController
    }
}
