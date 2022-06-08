import Combine
import UIKit

final class CallViewController: UIViewController {

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = ""
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private let stateLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = ""
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	// MARK: - Аудио/Видео

	private let audioVideoStackView: HStackView = {
		let stackView = HStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	// MARK: - Принять/Отклонить звонок

	private let answerEndCallStackView: HStackView = {
		let stackView = HStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private let viewModel: CallViewModelProtocol
	private var subscribtions: Set<AnyCancellable> = []

	init(viewModel: CallViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = viewModel.screenTitle
		nameLabel.text = viewModel.userName
		view.backgroundColor = .black
		configureViews()
		configureBindings()
		audioVideoStackView.setUp(model: viewModel.videoAudioStackModel)
		answerEndCallStackView.setUp(model: viewModel.answerEndCallStackModel)
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
		viewModel.controllerDidDisappear()
	}

	private func configureBindings() {

		viewModel.p2pCallStateTypePublisher
			.receive(on: RunLoop.main)
			.sink { [weak self] model in
				self?.updateUIDepending(on: model.0, callType: model.1)
			}.store(in: &subscribtions)
	}

	private func updateUIDepending(on callState: P2PCallState, callType: P2PCallType) {
		switch callState {
		case .createOffer, .ringing:
			stateLabel.text = callType == .incoming ? viewModel.sources.incomingCall : viewModel.sources.outcomingCall
		case .connecting:
			stateLabel.text = viewModel.sources.connectionIsEsatblishing
		case .connected:
			stateLabel.text = viewModel.sources.connectionIsEsatblished
		case .inviteExpired:
			stateLabel.text = viewModel.sources.userDoesNotRespond
		case .ended:
			stateLabel.text = viewModel.sources.callFinished
		default:
			stateLabel.text = ""
		}
	}
}

private extension CallViewController {

	func configureViews() {
		configureNameLabel()
		configureStateLabel()

		configureAnswerEndCallStackView()
		configureAudioVideoStackView()
	}

	// MARK: - Audio/Video

	func configureAudioVideoStackView() {
		view.addSubview(audioVideoStackView)
		NSLayoutConstraint.activate([
			audioVideoStackView.bottomAnchor.constraint(equalTo: answerEndCallStackView.topAnchor, constant: -30),
			audioVideoStackView.centerXAnchor.constraint(equalTo: answerEndCallStackView.centerXAnchor),
			audioVideoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			audioVideoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
		])
	}

	// MARK: - Answer/End

	func configureAnswerEndCallStackView() {
		view.addSubview(answerEndCallStackView)
		NSLayoutConstraint.activate([
			answerEndCallStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			answerEndCallStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
			answerEndCallStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			answerEndCallStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
		])
	}

	func configureNameLabel() {
		view.addSubview(nameLabel)
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
