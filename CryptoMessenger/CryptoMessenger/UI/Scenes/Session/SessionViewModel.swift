import SwiftUI
import Combine

// MARK: - SessionViewModel

final class SessionViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SessionSceneDelegate?

    @Published var sessionsList: [SessionItem] = []
    @Published var selectedSession = SessionItem.sessionsInfo()

    // MARK: - Private Properties

    @Published private(set) var state: SessionFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SessionFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SessionFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var matrixUseCase: MatrixUseCaseProtocol
    private let userSettings: UserCredentialsStorage & UserFlowsStorage

    // MARK: - Lifecycle

    init(
		userSettings: UserCredentialsStorage & UserFlowsStorage
	) {
		self.userSettings = userSettings
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    // MARK: - Internal Methods

    func send(_ event: SessionFlow.Event) {
        eventSubject.send(event)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onDeleteAll:
                    break
                case let .onDeleteOne(device):
                    break
                }
            }
            .store(in: &subscriptions)
		matrixUseCase.loginStatePublisher.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userSettings.isAuthFlowFinished = false
                self?.userSettings.isOnboardingFlowFinished = false
                self?.userSettings.isLocalAuth = false
                self?.userSettings.isLocalAuth = false
                self?.delegate?.restartFlow()
            default:
                break
            }
        }
        .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getSessions() {
		matrixUseCase.getDevicesWithActiveSessions { result in
            switch result {
            case let .success(devices):
                guard !devices.isEmpty else { return }
                var new_session_list: [SessionItem] = []
                for x in devices {
                    let lastSeenIp = x.lastSeenIp ?? ""
                    var dateSession = ""
                    let lastSeenTs = NSDate(timeIntervalSince1970: Double(
                        x.lastSeenTs) / 1000)
                        .description.split(separator: " ")
                    let date = lastSeenTs[0] + " " + lastSeenTs[1]
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    let dateFormatterSet = DateFormatter()
                    dateFormatterSet.dateFormat = "yyyy.MM.dd HH:mm"
                    if let date = dateFormatterGet.date(from: String(date)) {
                        dateSession = dateFormatterSet.string(from: date)
                    }
                    let displayName = x.displayName ?? ""
                    if !lastSeenIp.isEmpty && !displayName.isEmpty {
                        new_session_list.append(SessionItem(photo: R.image.session.smartphone.image,
                                                            deviceId: x.deviceId,
                                                            device: displayName,
                                                            place: "Москва, Россия",
                                                            date: dateSession,
                                                            ip: lastSeenIp))
                    }
                }
                self.sessionsList = new_session_list
                self.sessionsList = self.sessionsList.sorted(by: { $0.date > $1.date })
            case .failure:
                break
            }
        }
    }

    private func updateData() {
        getSessions()
    }
}
