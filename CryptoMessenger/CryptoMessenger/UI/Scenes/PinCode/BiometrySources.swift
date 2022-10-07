import Foundation

protocol BiometrySourcesable {

	static var touchIdAppEnter: String { get }

	static var faceIdAppEnter: String { get }

	static var touchIdEnable: String { get }

	static var faceIdEnable: String { get }

	static var touchIdEnableFailure: String { get }

	static var faceIdEnableFailure: String { get }
}

enum BiometrySources: BiometrySourcesable {

	static var touchIdAppEnter: String {
		R.string.localizable.biometryTouchIdAppEnter()
	}

	static var faceIdAppEnter: String {
		R.string.localizable.biometryFaceIdAppEnter()
	}

	static var touchIdEnable: String {
		R.string.localizable.biometryTouchIdEnable()
	}

	static var faceIdEnable: String {
		R.string.localizable.biometryFaceIdEnable()
	}

	static var touchIdEnableFailure: String {
		R.string.localizable.biometryTouchIdEnableFailure()
	}

	static var faceIdEnableFailure: String {
		R.string.localizable.biometryFaceIdEnableFailure()
	}
}
