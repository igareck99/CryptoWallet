import Combine
import Foundation

protocol HStackItemViewModelProtocol {
	var viewType: ViewConfigurable.Type { get }
}

struct HStackItemViewModel {
	let viewType: ViewConfigurable.Type
	let updateView: ((Bool, ButtonDownText) -> Void)?
	let action: ((ViewUpdatable) -> Void)?
	let isHidden: AnyPublisher<Bool, Never>?
	let isButtonEnabled: AnyPublisher<Bool, Never>?

	init(
		viewType: ViewConfigurable.Type = ButtonDownText.self,
		updateView: ((Bool, ButtonDownText) -> Void)?,
		action: ((ViewUpdatable) -> Void)?,
		isHidden: AnyPublisher<Bool, Never>? = nil,
		isButtonEnabled: AnyPublisher<Bool, Never>? = nil
	) {
		self.viewType = viewType
		self.updateView = updateView
		self.action = action
		self.isHidden = isHidden
		self.isButtonEnabled = isButtonEnabled
	}
}

// MARK: - ButtonViewModelProtocol

extension HStackItemViewModel: HStackItemViewModelProtocol {}
