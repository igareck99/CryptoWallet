import UIKit

final class HStackView: UIView {

	private let stackView: UIStackView = {
		let view = UIStackView()
		view.axis  = .horizontal
		view.alignment = .top
		view.distribution = .fillEqually
		view.spacing = 10
		view.backgroundColor = .clear
		view.isLayoutMarginsRelativeArrangement = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("Don't implement this initializer")
	}
}

private extension HStackView {
	func configureViews() {
		addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
	}
}

// MARK: - HorizontalStackable

extension HStackView: ViewConfigurable {
	func setUp(model: Any?) {
		guard stackView.arrangedSubviews.isEmpty,
			  let viewModel = model as? HStackViewModel else { return }
		viewModel.viewModels.forEach {
			let view = $0.viewType.init()
			view.setUp(model: $0)
			stackView.addArrangedSubview(view)
		}
	}
}
