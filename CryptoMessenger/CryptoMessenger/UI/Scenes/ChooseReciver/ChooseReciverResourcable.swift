import SwiftUI
import Foundation

// MARK: - ChooseReciverSourcable

protocol ChooseReciverSourcable {

    static var qrcode: Image { get }

    static var chooseReceiverTitle: String { get }

    static var countryCodePickerSearch: String { get }
}

// MARK: - ChooseReciverSources(ChooseReciverSourcable)

enum ChooseReciverSources: ChooseReciverSourcable {

    static var qrcode: Image {
        R.image.chooseReceiver.qrcode.image
    }

    static var chooseReceiverTitle: String {
        R.string.localizable.chooseReceiverTitle()
    }

    static var countryCodePickerSearch: String {
        R.string.localizable.countryCodePickerSearch()
    }
}
