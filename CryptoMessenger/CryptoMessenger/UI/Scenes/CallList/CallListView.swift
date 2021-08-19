//
//  CallListView.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 19.08.2021
//  
//

import UIKit

// MARK: - CallListView

final class CallListView: UIView {

    // MARK: - Internal Properties

    var didTap: (() -> Void)?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        background(.green())
        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: - Internal Methods

    func publicMethod() {

    }

    // MARK: - Private Methods

    private func setup() {

    }
}
