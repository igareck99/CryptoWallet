import SwiftUI

protocol FacilityApproveSourcesable {
	static var facilityApproveTransactionSum: String { get }

	static var facilityApproveInUSD: String { get }

	static var facilityApproveCommission: String { get }

	static var facilityApproveAddress: String { get }

	static var facilityApproveDocumentDate: String { get }
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
}
