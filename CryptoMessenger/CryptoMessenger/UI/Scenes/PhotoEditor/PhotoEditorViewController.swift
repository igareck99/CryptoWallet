//
//  PhotoEditorViewController.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 30.08.2021
//  
//

import UIKit

// MARK: PhotoEditorViewController

final class PhotoEditorViewController: BaseViewController {

    // MARK: - Internal Properties

    var presenter: PhotoEditorPresentation!

    // MARK: - Private Properties

    private lazy var customView = PhotoEditorView(frame: UIScreen.main.bounds)

    // MARK: - Lifecycle

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.background(.red())

    }

}

// MARK: - PhotoEditorViewInterface

extension PhotoEditorViewController: PhotoEditorViewInterface {
    func showAlert(title: String?, message: String?) {
        presentAlert(title: title, message: message)
    }
}
