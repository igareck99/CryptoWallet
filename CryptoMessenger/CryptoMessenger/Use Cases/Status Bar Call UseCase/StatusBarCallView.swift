import UIKit

// MARK: - StatusBarCallViewDelegate

protocol StatusBarCallViewDelegate: AnyObject {

	func didTapCallStatusView()

}

// MARK: - StatusBarCallViewProtocol

protocol StatusBarCallViewProtocol {

	func animateStatusView(show: Bool)

}

// MARK: - StatusBarCallView

final class StatusBarCallView: UIView {

    // MARK: - Private Properties

	private let callLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = "Вернуться к звонку"
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private let coloredView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemGreen
		return view
	}()

	private var statusBarHeight: CGFloat {
		UIApplication.shared.statusBarFrame.size.height
	}

    // MARK: - Internal Properties

	var heightConstraint: NSLayoutConstraint?
	var coloredViewHeightConstraint: NSLayoutConstraint?
	weak var delegate: StatusBarCallViewDelegate?

    // MARK: - Lifecycle

	init(
		appWindow: UIWindow,
		delegate: StatusBarCallViewDelegate? = nil
	) {
		super.init(frame: .zero)
		self.delegate = delegate
		configureViews(appWindow: appWindow)
		addTapGesture()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapColoredView))
		coloredView.addGestureRecognizer(tapGesture)
	}

	@objc func didTapColoredView() {
		delegate?.didTapCallStatusView()
	}
}

// MARK: - StatusBarCallView(StatusBarCallViewProtocol)

extension StatusBarCallView: StatusBarCallViewProtocol {
	func animateStatusView(show: Bool) {
		self.coloredViewHeightConstraint?.constant = show ? 30 : 0
		self.heightConstraint?.constant = show ? statusBarHeight + 30 : 0
	}
}

// MARK: - StatusBarCallView

private extension StatusBarCallView {

	func configureViews(appWindow: UIWindow) {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .white

		configureCallLabelView()
		configureColoredView()
		configureView(appWindow: appWindow)
	}

	func configureCallLabelView() {
		coloredView.addSubview(callLabel)
		NSLayoutConstraint.activate([
			callLabel.topAnchor.constraint(equalTo: coloredView.topAnchor),
			callLabel.leadingAnchor.constraint(equalTo: coloredView.leadingAnchor),
			callLabel.bottomAnchor.constraint(equalTo: coloredView.bottomAnchor),
			callLabel.trailingAnchor.constraint(equalTo: coloredView.trailingAnchor)
		])
	}

	func configureColoredView() {
		let coloredHConstraint = coloredView.heightAnchor.constraint(equalToConstant: .zero)
		coloredViewHeightConstraint = coloredHConstraint
		addSubview(coloredView)
		NSLayoutConstraint.activate([
			coloredView.topAnchor.constraint(equalTo: topAnchor, constant: statusBarHeight),
			coloredView.leadingAnchor.constraint(equalTo: leadingAnchor),
			coloredView.trailingAnchor.constraint(equalTo: trailingAnchor),
			coloredView.bottomAnchor.constraint(equalTo: bottomAnchor),
			coloredHConstraint
		])
	}

	func configureView(appWindow: UIWindow) {

		guard let rootView = appWindow.rootViewController else { assertionFailure("Не установлен rootView"); return }
		let hConstraint = heightAnchor.constraint(equalToConstant: .zero)
		heightConstraint = hConstraint
		appWindow.addSubview(self)
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: appWindow.topAnchor),
			leadingAnchor.constraint(equalTo: appWindow.leadingAnchor),
			trailingAnchor.constraint(equalTo: appWindow.trailingAnchor),
			bottomAnchor.constraint(equalTo: rootView.view.topAnchor),
			hConstraint
		])
	}
}
