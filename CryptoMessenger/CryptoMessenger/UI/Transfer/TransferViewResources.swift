import Foundation
import SwiftUI

protocol TransferViewSourcable {

	static var transferSlow: String { get }

	static var transferMiddle: String { get }

	static var transferFast: String { get }

    static var transferTransfer: String { get }

    static var transferTransferError: String { get }

    static var transferYourAdress: String { get }

    static var transferToWhom: String { get }

    static var transferSum: String { get }

    static var transferChooseContact: String { get }

    static var walletSend: String { get }

    static var chatLogo: Image { get }

    static var logo: Image { get }

    static var contact: Image { get }

    static var textColor: Color { get }

    static var background: Color { get }

    static var avatarBackground: Color { get }

    static var titleColor: Color { get }

    static var inactiveButtonTextColor: Color { get }

    static var inactiveButtonBackground: Color { get }

    static var buttonColor: Color { get }
}

enum TransferViewSources: TransferViewSourcable {

	static var transferSlow: String {
		R.string.localizable.transferSlow()
	}

	static var transferMiddle: String {
		R.string.localizable.transferMiddle()
	}

	static var transferFast: String {
		R.string.localizable.transferQuick()
	}

    static var transferTransfer: String {
        R.string.localizable.transferTransfer()
    }

    static var transferTransferError: String {
        R.string.localizable.transferTransferError()
    }

    static var transferYourAdress: String {
        R.string.localizable.transferYourAdress()
    }

    static var transferToWhom: String {
        R.string.localizable.transferToWhom()
    }

    static var transferSum: String {
        R.string.localizable.transferSum()
    }

    static var transferChooseContact: String {
        R.string.localizable.transferChooseContact()
    }

    static var walletSend: String {
        R.string.localizable.walletSend()
    }

    static var chatLogo: Image {
        R.image.chat.logo.image
    }

    static var logo: Image {
        R.image.chat.logo.image
    }

    static var contact: Image {
        R.image.chat.action.contact.image
    }

    static var textColor: Color {
        .romanSilver
    }

    static var background: Color {
        .white 
    }

    static var avatarBackground: Color {
        .dodgerTransBlue
    }

    static var titleColor: Color {
        .chineseBlack
    }

    static var inactiveButtonTextColor: Color {
        .ashGray
    }

    static var inactiveButtonBackground: Color {
            .ghostWhite
    }

    static var buttonColor: Color {
        .dodgerBlue
    }
}
