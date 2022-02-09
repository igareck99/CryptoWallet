import SwiftUI
import Combine

// MARK: - SessionViewModel

class SessionViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SessionSceneDelegate?

    @Published var listData: [SessionItem] = []

    // MARK: - Private Properties

    @Published private(set) var state: SessionFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<SessionFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SessionFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
    @Injectable private(set) var mxStore: MatrixStore

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
                }
            }
            .store(in: &subscriptions)

        mxStore.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in

            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func getSessions() {
        print("called")
        self.mxStore.getActiveSessions { result in
            switch result {
            case let .success(devices):
                if !devices.isEmpty {
                    for x in devices {
                        let lastSeenIp = x.lastSeenIp ?? ""
                        let lastSeenTs = x.lastSeenTs
                        let displayName = x.displayName ?? ""
                        var photo = UIImage()
                        if !displayName.isEmpty {
                            if displayName.contains("iPhone") {
                                photo = R.image.session.ios() ?? UIImage()
                            } else {
                                photo = R.image.session.android() ?? UIImage()
                            }
                        }
                        if !lastSeenIp.isEmpty && lastSeenTs != 0 && !displayName.isEmpty {
                            self.listData.append(SessionItem(photo: photo,
                                                             device: displayName,
                                                             place: "Москва, Россия",
                                                             date: String(lastSeenTs),
                                                             ip: lastSeenIp))
                        }
                    }
                }
            case .failure(_):
                print("error")
            }
        }
    }

    private func updateData() {
        getSessions()
    }
}
