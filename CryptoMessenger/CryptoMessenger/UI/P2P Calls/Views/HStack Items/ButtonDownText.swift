import Combine
import UIKit

final class ButtonDownText: UIView {

	lazy var actionButton: UIButton = {
		let button = UIButton()
		button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 35
		button.tintColor = .white
		button.imageView?.contentMode = .scaleAspectFill
		return button
	}()

	let underButtonLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = ""
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private var buttonAction: ((ViewUpdatable) -> Void)?
	private var cancellables = Set<AnyCancellable>()
	var update: ((Bool, ButtonDownText) -> Void)?

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc
	private func didTapAction() {
		debugPrint("didTapActionButton")
		buttonAction?(self)
	}
}

private extension ButtonDownText {
	func configureViews() {
		backgroundColor = .clear
		configureActionButton()
		configureUnderButtonLabel()
	}

	func configureActionButton() {
		addSubview(actionButton)
		NSLayoutConstraint.activate([
			actionButton.topAnchor.constraint(equalTo: topAnchor),
			actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			actionButton.widthAnchor.constraint(equalToConstant: 70),
			actionButton.heightAnchor.constraint(equalToConstant: 70)
		])
	}

	func configureUnderButtonLabel() {
		addSubview(underButtonLabel)
		NSLayoutConstraint.activate([
			underButtonLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 8),
			underButtonLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			underButtonLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			underButtonLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}

// MARK: - ViewUpdatable

extension ButtonDownText: ViewUpdatable {
	func updateView(isEnabled: Bool) {
		update?(isEnabled, self)
	}
}

// MARK: - ViewConfigurable

extension ButtonDownText: ViewConfigurable {

	func setUp(model: Any?) {
		guard let viewModel = model as? HStackItemViewModel else { return }
		buttonAction = viewModel.action
		update = viewModel.updateView
		updateView(isEnabled: false)

		viewModel.isHidden?
			.receive(on: RunLoop.main)
			.sink { [weak self] isHidden in
				self?.isHidden = isHidden
			}.store(in: &cancellables)
	}
}
