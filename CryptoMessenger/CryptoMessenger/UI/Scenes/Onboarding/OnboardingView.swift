//
//  OnboardingView.swift
//  CryptoMessenger
//
//  Created by Dmitrii Ziablikov on 21.06.2021
//  
//

import UIKit

// MARK: - OnboardingView

final class OnboardingView: UIView {

    // MARK: - Internal Properties

    var didNextSceneTap: (() -> Void)?

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = .init()
    private lazy var descriptionLabel: UILabel = .init()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.white())
        addTitleLabel()
        addDescriptionLabel()
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
            $0.top.equalTo($1).offset(44)
            $0.leading.equalTo($1).offset(15)
            $0.trailing.equalTo($1).offset(-15)
        }
    }

    private func addDescriptionLabel() {
        descriptionLabel.snap(parent: self) {
            $0.text = "Description"
        } layout: {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo($1).offset(15)
            $0.trailing.equalTo($1).offset(-15)
        }
    }
}
