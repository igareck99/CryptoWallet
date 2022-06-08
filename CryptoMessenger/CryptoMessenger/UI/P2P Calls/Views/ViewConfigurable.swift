import UIKit

protocol ViewConfigurable: UIView {
	func setUp(model: Any?)
}

protocol ViewUpdatable: UIView {
	func updateView(isEnabled: Bool)
}
