//
//  PhotoEditorFlow.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 30.08.2021
//  
//

import Foundation

// MARK: - PhotoEditorFlow

enum PhotoEditorFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
