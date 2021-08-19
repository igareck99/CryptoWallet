//
//  CallListPresenter.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 19.08.2021
//  
//

import Foundation

// MARK: - CallListPresenter

final class CallListPresenter {

    // MARK: - Internal Properties

    weak var delegate: CallListSceneDelegate?
    weak var view: CallListViewInterface?

    private var state = CallListFlow.ViewState.sending {
        didSet {
            updateView(state)
        }
    }

    // MARK: - Lifecycle

    init(view: CallListViewInterface) {
        self.view = view
    }

    // MARK: - Internal Methods

    func updateView(_ state: CallListFlow.ViewState) {
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

// MARK: - CallListPresenter (CallListPresentation)

extension CallListPresenter: CallListPresentation {
    func handleButtonTap() {

    }
}
