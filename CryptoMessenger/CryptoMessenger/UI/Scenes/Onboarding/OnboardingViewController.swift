//
//  OnboardingViewController.swift
//  CryptoMessenger
//
//  Created by Dmitrii Ziablikov on 21.06.2021
//  
//

import UIKit

// MARK: OnboardingViewController

final class OnboardingViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: OnboardingPresentation!

    // MARK: - Private Properties

    private lazy var customView = OnboardingView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnCustomViewActions()
    }

    // MARK: - Private Methods

    private func subscribeOnCustomViewActions() {
        customView.didNextSceneTap = { [unowned self] in
            self.presenter.handleNextScene()
        }
    }
}

// MARK: - OnboardingViewInterface

extension OnboardingViewController: OnboardingViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
