//
//  OnboardingFlow.swift
//  CryptoMessenger
//
//  Created by Dmitrii Ziablikov on 21.06.2021
//  
//

import Foundation

// MARK: OnboardingFlow

enum OnboardingFlow {

    // MARK: - Types

    enum ViewState {
        case sending
        case result
        case error(message: String)
    }
}
