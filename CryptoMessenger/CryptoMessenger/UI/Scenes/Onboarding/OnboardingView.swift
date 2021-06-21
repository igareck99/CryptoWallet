//
//  OnboardingView.swift
//  CryptoMessenger
//
//  Created by Dmitrii Ziablikov on 21.06.2021
//  
//

import UIKit

// MARK: OnboardingView

final class OnboardingView: UIView {

    // MARK: - Internal Properties

    var didNextSceneTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = .init()


    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addTitleLabel()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Public Methods

    func publicMethod() {

    }

    // MARK: - Private Methods

    private func addTitleLabel() {
        titleLabel.snap(parent: self) {
            $0.text = "Title"
        } layout: {
            $0.center.equalTo($1)
        }
    }
}
