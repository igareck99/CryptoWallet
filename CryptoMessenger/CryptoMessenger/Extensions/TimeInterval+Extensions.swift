import Foundation

extension TimeInterval {
	var hours: Int {
		Int(self / 3600)
	}

	var minutes: Int {
		Int(self / 60)
	}

	var seconds: Int {
		Int(self / 60)
	}
}
