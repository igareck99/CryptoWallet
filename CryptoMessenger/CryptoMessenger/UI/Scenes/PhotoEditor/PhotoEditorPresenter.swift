//
//  PhotoEditorPresenter.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 30.08.2021
//  
//

import Foundation

// MARK: - PhotoEditorPresenter

final class PhotoEditorPresenter {

    // MARK: - Internal Properties

    weak var delegate: PhotoEditorSceneDelegate?
    weak var view: PhotoEditorViewInterface?

    private var state = PhotoEditorFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: PhotoEditorViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: PhotoEditorFlow.ViewState) {
        switch state {
        case .sending:
            print("sending..")
        case .result:
            print("result")
        case .error(let message):
            view?.showAlert(title: nil, message: message)
        }
    }
}

// MARK: - PhotoEditorPresenter (PhotoEditorPresentation)

extension PhotoEditorPresenter: PhotoEditorPresentation {
    func handleButtonTap() {

    }
}
