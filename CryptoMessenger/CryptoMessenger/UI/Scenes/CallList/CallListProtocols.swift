//
//  CallListProtocols.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 19.08.2021
//  
//

import Foundation

// MARK: - CallListSceneDelegate

protocol CallListSceneDelegate: AnyObject {
    func handleButtonTap(_ scene: AuthFlowCoordinator.Scene)
}

// MARK: - CallListViewInterface

protocol CallListViewInterface: AnyObject {
    func showAlert(title: String?, message: String?)
}

// MARK: - CallListPresentation

protocol CallListPresentation: AnyObject {
    func handleButtonTap()
}
