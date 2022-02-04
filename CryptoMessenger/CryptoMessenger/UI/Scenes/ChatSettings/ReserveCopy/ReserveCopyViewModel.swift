import SwiftUI
import Combine

final class ReserveCopyViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ReserveCopySceneDelegate?

    // MARK: - Private Properties

    @Published var reserveCopyTime = ""
    @Published private(set) var state: ReserveCopyFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ReserveCopyFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ReserveCopyFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Internal Methods

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

    func send(_ event: ReserveCopyFlow.Event) {
        eventSubject.send(event)
    }

    func updateReserveCopyTime(item: String) {
        reserveCopyTime = item
        userCredentialsStorageService.reserveCopyTime = reserveCopyTime
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
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func updateData() {
        reserveCopyTime = userCredentialsStorageService.reserveCopyTime
    }
}
