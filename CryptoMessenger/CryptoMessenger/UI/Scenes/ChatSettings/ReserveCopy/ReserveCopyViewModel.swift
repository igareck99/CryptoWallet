import SwiftUI
import Combine

// MARK: - ReserveCopyViewModel

final class ReserveCopyViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ReserveCopySceneDelegate?

    // MARK: - Private Properties

    @Published var reserveCopyTime = ""
    @Published var progressValue = Float(1)
    @Published var percent = Float(0)
    @Published var size_of_data = Float(0)
    @Published var uploadSpeed = Float(0.1)
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

    func reserveCopyProgress() {
        self.progressValue += 0.1
        self.percent = self.progressValue / self.size_of_data
        if (self.progressValue + self.uploadSpeed) / self.size_of_data > 1 {
            self.progressValue = self.size_of_data
            self.percent = 1
        }
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onUpload:
                    self?.reserveCopyProgress()
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
        size_of_data = 5
        percent = 0.0
        progressValue = 0.0
    }
}
