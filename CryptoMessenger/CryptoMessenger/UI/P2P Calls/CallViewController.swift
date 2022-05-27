import UIKit

protocol CallViewControllerDelegate: AnyObject {

	func acceptCallButtonDidTap()

	func endCallButtonDidTap()

	func controllerDidDisappear()
}

final class CallViewController: UIViewController {

	private let callButtonsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .center
		stackView.distribution = .equalSpacing
		stackView.axis = .horizontal
		stackView.spacing = 50
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var endCallButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(didTapEndCall(button:)), for: .touchUpInside)
		let image = UIImage(systemName: "phone.down.fill")
		button.setImage(image, for: .normal)
		button.tintColor = .white
		button.layer.cornerRadius = 35
		button.backgroundColor = .systemRed
		button.imageView?.contentMode = .scaleAspectFill
		return button
	}()

	private lazy var acceptCallButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(didTapAcceptCall(button:)), for: .touchUpInside)
		let image = UIImage(systemName: "phone.fill")
		button.setImage(image, for: .normal)
		button.tintColor = .white
		button.layer.cornerRadius = 35
		button.backgroundColor = .systemGreen
		button.imageView?.contentMode = .scaleAspectFill
		return button
	}()

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = "Aura User"
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private let stateLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = "Соединение устанавливается"
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	weak var delegate: CallViewControllerDelegate?
	private let userName: String
	// TODO: Доделать логику обновление состояния экрана
	// Эти проперти только для старта экрана, потом они становятся неактуальными
	private let callType: P2PCallUseCase.CallType
	private let callState: P2PCallUseCase.CallState

	init(
		userName: String,
		callState: P2PCallUseCase.CallState,
		callType: P2PCallUseCase.CallType,
		delegate: CallViewControllerDelegate
	) {
		self.userName = userName
		self.callState = callState
		self.callType = callType
		self.delegate = delegate
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Защищено сквозным шифрованием"
		view.backgroundColor = .black
		configureStackView()
		configureEndCallButton()
		configureAcceptCallButton()
		configureNameLabel()
		configureStateLabel()
		acceptCallButton.isHidden = callType == .outcoming || callState != .calling
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithTransparentBackground()
		navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.backgroundColor = .black

		navigationItem.scrollEdgeAppearance = navigationBarAppearance
		navigationItem.standardAppearance = navigationBarAppearance
		navigationItem.compactAppearance = navigationBarAppearance
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		delegate?.controllerDidDisappear()
	}

	@objc private func didTapEndCall(button: UIButton) {
		delegate?.endCallButtonDidTap()
	}

	@objc private func didTapAcceptCall(button: UIButton) {
		delegate?.acceptCallButtonDidTap()
	}
}

private extension CallViewController {

	func configureStackView() {
		view.addSubview(callButtonsStackView)
		NSLayoutConstraint.activate([
			callButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			callButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
		])
	}

	func configureEndCallButton() {
		callButtonsStackView.addArrangedSubview(endCallButton)
		NSLayoutConstraint.activate([
			endCallButton.widthAnchor.constraint(equalToConstant: 70),
			endCallButton.heightAnchor.constraint(equalToConstant: 70)
		])
	}

	func configureAcceptCallButton() {
		callButtonsStackView.addArrangedSubview(acceptCallButton)
		NSLayoutConstraint.activate([
			acceptCallButton.widthAnchor.constraint(equalToConstant: 70),
			acceptCallButton.heightAnchor.constraint(equalToConstant: 70)
		])
	}

	func configureNameLabel() {
		view.addSubview(nameLabel)
		nameLabel.text = userName
		NSLayoutConstraint.activate([
			nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
			nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
			nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
		])
	}

	func configureStateLabel() {
		view.addSubview(stateLabel)
		NSLayoutConstraint.activate([
			stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
			stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
			stateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
		])
	}
}

// MARK: - P2PCallUseCaseDelegate

extension CallViewController: P2PCallUseCaseDelegate {
	func callDidChange(state: P2PCallUseCase.CallState) {
		switch state {
		case .connecting:
			stateLabel.text = "Соединение устанавливается"
		case .connected:
			stateLabel.text = "Соединение установлено"
		case .inviteExpired:
			stateLabel.text = "Пользователь не отвечает"
		case .ended:
			stateLabel.text = "Звонок завершен"
		default:
			stateLabel.text = ""
		}
		acceptCallButton.isHidden = callType == .outcoming || state != .calling
	}
}
