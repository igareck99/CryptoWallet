import SwiftUI
import Combine

// MARK: - SessionViewModel

class SessionViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SessionSceneDelegate?

    @Published var sessionsList: [SessionItem] = []

    // MARK: - Private Properties

    @Published private(set) var state: SessionFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SessionFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SessionFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userFlowsStorageService: UserFlowsStorageService
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Lifecycle

    init() {
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
                    self?.mxStore.logout()
                case let .onDeleteOne(device):
                    self?.mxStore.removeDevice(device, completion: {
                    })
                }
            }
            .store(in: &subscriptions)
        mxStore.$loginState.sink { [weak self] status in
            switch status {
            case .loggedOut:
                self?.userFlowsStorageService.isAuthFlowFinished = false
                self?.userFlowsStorageService.isOnboardingFlowFinished = false
                self?.userFlowsStorageService.isLocalAuth = false
                self?.userFlowsStorageService.isPinCodeOn = false
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
        self.mxStore.getActiveSessions { result in
            switch result {
            case let .success(devices):
                if !devices.isEmpty {
                    for x in devices {
                        let lastSeenIp = x.lastSeenIp ?? ""
                        var dateSession = ""
                        let lastSeenTs = NSDate(timeIntervalSince1970: Double(
                            x.lastSeenTs / 1000))
                            .description.split(separator: " ")
                        let date = lastSeenTs[0] + " " + lastSeenTs[1]
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateFormatterSet = DateFormatter()
                        dateFormatterSet.dateFormat = "yyyy-MM-dd HH:mm"
                        if let date = dateFormatterGet.date(from: String(date)) {
                            dateSession = dateFormatterSet.string(from: date)
                        }
                        let displayName = x.displayName ?? ""
                        var photo = UIImage()
                        if !displayName.isEmpty {
                            if displayName.contains("iPhone") {
                                photo = R.image.session.ios() ?? UIImage()
                            } else {
                                photo = R.image.session.android() ?? UIImage()
                            }
                        }
                        if !lastSeenIp.isEmpty && !displayName.isEmpty {
                            self.sessionsList.append(SessionItem(photo: photo,
                                                                 device_id: x.deviceId,
                                                                 device: displayName,
                                                                 place: "Москва, Россия",
                                                                 date: dateSession,
                                                                 ip: lastSeenIp))
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
    }

    private func updateData() {
        getSessions()
    }
}
