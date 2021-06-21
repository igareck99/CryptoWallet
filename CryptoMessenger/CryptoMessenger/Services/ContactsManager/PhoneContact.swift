//
//  PhoneContact.swift
//  Greetty
//
//  Created by Dmitrii Ziablikov on 23.05.2021.
//

import Foundation

struct PhoneContact: Identifiable {
    let id = UUID().uuidString
    let identifier: String
    let givenName: String
    let familyName: String
    let image: Data?
    let phoneNumber: String
    let numberLabel: String
}
