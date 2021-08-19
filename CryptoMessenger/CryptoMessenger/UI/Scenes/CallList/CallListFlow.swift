//
//  CallListFlow.swift
//  CryptoMessenger
//
//  Created by Игорь Коноваленко on 19.08.2021
//  
//

import Foundation

// MARK: - CallListFlow

enum CallListFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
