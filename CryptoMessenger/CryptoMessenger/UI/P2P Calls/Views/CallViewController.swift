import Combine
import UIKit

// MARK: - CallViewController

final class CallViewController: UIViewController {

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = ""
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private let stateLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = ""
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private let callDurationLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.text = ""
		label.textAlignment = .center
		label.lineBreakMode = .byTruncatingTail
		return label
	}()

	private lazy var stateImage: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.image = viewModel.sources.callIsHoldedImage
		imageView.isHidden = true
		imageView.alpha = 0.4
		return imageView
	}()
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.frame = view.bounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()

	private let stateView: UIView = {
		let stateImageView = UIView()
		stateImageView.translatesAutoresizingMaskIntoConstraints = false
		return stateImageView
	}()

	// MARK: - Видео

	private let interlocutorView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let selfView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let interlocutorCallView: UIView?
	private let selfCallView: UIView?

	// MARK: - Удержание

	private let holdStackView: HStackView = {
		let stackView = HStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
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

	init(
		viewModel: CallViewModelProtocol,
		interlocutorCallView: UIView?,
		selfCallView: UIView?
	) {
		self.viewModel = viewModel
		self.interlocutorCallView = interlocutorCallView
		self.selfCallView = selfCallView
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad() 
        navigationItem.title = viewModel.screenTitle
		nameLabel.text = viewModel.userName
		view.backgroundColor = .black
		configureViews()
		configureBindings()
		holdStackView.setUp(model: viewModel.holdStackModel)
		audioVideoStackView.setUp(model: viewModel.videoAudioStackModel)
		answerEndCallStackView.setUp(model: viewModel.answerEndCallStackModel)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// TODO: Проработать отображение нав бара при рефакторинге формирования навигационного стека
		navigationController?.setNavigationBarHidden(false, animated: true)

		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                       .font:  UIFont.systemFont(ofSize: 15, weight: .regular)]
		navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

		navigationController?.navigationBar.tintColor = .white
		navigationController?.navigationBar.backgroundColor = .black

		navigationItem.scrollEdgeAppearance = navigationBarAppearance
		navigationItem.standardAppearance = navigationBarAppearance
		navigationItem.compactAppearance = navigationBarAppearance

		viewModel.controllerWillAppear()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel.controllerDidAppear()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel.controllerDidDisappear()
	}

	private func configureBindings() {

		viewModel.callStateTypeSubject
			.receive(on: RunLoop.main)
			.sink { [weak self] model in
				self?.updateUIDepending(on: model.0, callType: model.1)
			}.store(in: &subscribtions)

		viewModel.activeCallerNameSubject
			.receive(on: RunLoop.main)
			.sink { [weak self] callerName in
				self?.nameLabel.text = callerName
			}.store(in: &subscribtions)

		viewModel.callDurationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] duration in
                guard let self = self else { return }
                self.callDurationLabel.text = duration
            }.store(in: &subscribtions)
        viewModel.imageLoadedSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.view.addBackground(value)
                self?.navigationController?.navigationBar.backgroundColor = .clear
            }.store(in: &subscribtions)
	}

	private func updateUIDepending(on callState: P2PCallState, callType: P2PCallType) {
		stateImage.isHidden = callState != .remotelyOnHold && callState != .onHold

		switch callState {
        case .createOffer, .ringing:
			stateLabel.text = callType == .incoming ? viewModel.sources.incomingCall : viewModel.sources.outcomingCall
        case .connecting:
			stateLabel.text = viewModel.sources.connectionIsEsatblishing
        case .connected:
            stateLabel.text = viewModel.sources.connectionIsEsatblished
        case .inviteExpired:
            stateLabel.text = viewModel.sources.userDoesNotRespond
		case .onHold:
			stateLabel.text = viewModel.sources.youHoldedCall
		case .remotelyOnHold:
			stateLabel.text = viewModel.sources.otherIsHoldedCall
		case .ended:
			stateLabel.text = viewModel.sources.callFinished
		default:
			stateLabel.text = ""
		}
	}
}

private extension CallViewController {

	func configureViews() {
		configureInterlocutorVideoView()
		configureSelfVideoView()

		configureSelfVideoViewIfExist()
		configureInterlocutorVideoViewIfExist()

		configureNameLabel()
		configureStateLabel()
		configureCallDurationLabel()

		configureAnswerEndCallStackView()
		configureAudioVideoStackView()
		// TODO: Пока hold/unhold не выделяем в отдельный стек
//		configureHoldStackView()

		configureStateView()
		configureStateImageView()
	}

	// MARK: - State image view

	func configureStateView() {
		view.addSubview(stateView)
		NSLayoutConstraint.activate([
			stateView.topAnchor.constraint(equalTo: callDurationLabel.bottomAnchor),
			stateView.bottomAnchor.constraint(equalTo: audioVideoStackView.topAnchor),
			stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	func configureStateImageView() {
		stateView.addSubview(stateImage)
		NSLayoutConstraint.activate([
			stateImage.centerXAnchor.constraint(equalTo: stateView.centerXAnchor),
			stateImage.centerYAnchor.constraint(equalTo: stateView.centerYAnchor),
			stateImage.widthAnchor.constraint(equalToConstant: 70),
			stateImage.heightAnchor.constraint(equalToConstant: 70)
		])
	}

    func configureBackround() {
        view.addSubview(avatar)
    }

	// MARK: - Hold

	func configureHoldStackView() {
		view.addSubview(holdStackView)
		NSLayoutConstraint.activate([
			holdStackView.bottomAnchor.constraint(equalTo: audioVideoStackView.topAnchor, constant: -30),
			holdStackView.centerXAnchor.constraint(equalTo: audioVideoStackView.centerXAnchor),
			holdStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			holdStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
		])
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

	// MARK: - Video views

	func configureInterlocutorVideoView() {
		view.addSubview(interlocutorView)
		NSLayoutConstraint.activate([
			interlocutorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			interlocutorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			interlocutorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			interlocutorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	func configureSelfVideoView() {
		view.addSubview(selfView)
		selfView.layer.cornerRadius = 10
		selfView.clipsToBounds = true
		NSLayoutConstraint.activate([
			selfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
			selfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			selfView.widthAnchor.constraint(equalToConstant: 120),
			selfView.heightAnchor.constraint(equalToConstant: 180)
		])
	}

	func configureSelfVideoViewIfExist() {
		guard let selfVideoView = selfCallView else { return }
		selfVideoView.translatesAutoresizingMaskIntoConstraints = false
		selfVideoView.constraints.forEach { $0.isActive = false }
		selfView.addSubview(selfVideoView)
		NSLayoutConstraint.activate([
			selfVideoView.topAnchor.constraint(equalTo: selfView.topAnchor),
			selfVideoView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor),
			selfVideoView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor),
			selfVideoView.bottomAnchor.constraint(equalTo: selfView.bottomAnchor)
		])
	}

	func configureInterlocutorVideoViewIfExist() {
		guard let interlocutorVideoView = interlocutorCallView else { return }
		interlocutorVideoView.translatesAutoresizingMaskIntoConstraints = false
		interlocutorVideoView.constraints.forEach { $0.isActive = false }
		interlocutorView.addSubview(interlocutorVideoView)
		NSLayoutConstraint.activate([
			interlocutorVideoView.topAnchor.constraint(equalTo: interlocutorView.topAnchor),
			interlocutorVideoView.trailingAnchor.constraint(equalTo: interlocutorView.trailingAnchor),
			interlocutorVideoView.leadingAnchor.constraint(equalTo: interlocutorView.leadingAnchor),
			interlocutorVideoView.bottomAnchor.constraint(equalTo: interlocutorView.bottomAnchor)
		])
	}

	// MARK: - Answer/End

	func configureAnswerEndCallStackView() {
		view.addSubview(answerEndCallStackView)
		NSLayoutConstraint.activate([
			answerEndCallStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			answerEndCallStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
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

	func configureCallDurationLabel() {
		view.addSubview(callDurationLabel)
		NSLayoutConstraint.activate([
			callDurationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			callDurationLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 16),
			callDurationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
			callDurationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
		])
	}
}
