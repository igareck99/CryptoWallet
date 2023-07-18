import SwiftUI

protocol FacilityApproveSourcesable {
	static var facilityApproveTransactionSum: String { get }

	static var facilityApproveInUSD: String { get }

	static var facilityApproveCommission: String { get }

	static var facilityApproveAddress: String { get }

	static var facilityApproveDocumentDate: String { get }
    
    static var facilityApproveValidateTransaction: String { get }
    
    static var facilityApproveReceiver: String { get }
    
    static var facilityApproveCheck: String { get }
    
    static var walletSend: String { get }
    
    
    
    static var userPlaceholder: Image { get }
    
    
    
    static var background: Color { get }
    
    static var checkTextColor: Color { get }
    
    static var textColor: Color { get }
    
    static var buttonBackground: Color { get }
    
    static var titleColor: Color { get }
}

enum FacilityApproveSources: FacilityApproveSourcesable {

	static var facilityApproveTransactionSum: String {
		R.string.localizable.facilityApproveTransactionSum()
	}

	static var facilityApproveInUSD: String {
		R.string.localizable.facilityApproveInUSD()
	}

	static var facilityApproveCommission: String {
		R.string.localizable.facilityApproveCommission()
	}

	static var facilityApproveAddress: String {
		R.string.localizable.facilityApproveAddress()
	}

	static var facilityApproveDocumentDate: String {
		R.string.localizable.facilityApproveDocumentDate()
	}
    
    static var facilityApproveValidateTransaction: String {
        R.string.localizable.facilityApproveValidateTransaction()
    }
    
    static var facilityApproveReceiver: String {
        R.string.localizable.facilityApproveReceiver()
    }
    
    static var facilityApproveCheck: String {
        R.string.localizable.facilityApproveCheck()
    }
    
    static var walletSend: String {
        R.string.localizable.walletSend()
    }
    
    
    
    static var userPlaceholder: Image {
        R.image.transaction.userPlaceholder.image
    }
    
    
    
    static var background: Color {
        .white 
    }
    
    static var checkTextColor: Color {
        .royalOrange
    }
    
    static var textColor: Color {
        .romanSilver
    }
    
    static var buttonBackground: Color {
        .dodgerBlue
    }
    
    static var titleColor: Color {
        .chineseBlack
    }
}
