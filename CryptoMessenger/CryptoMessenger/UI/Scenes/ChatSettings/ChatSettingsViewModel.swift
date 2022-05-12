import Combine
import SwiftUI

final class ChatSettingsViewModel: ObservableObject {

    // MARK: - Private Properties    
    @Published var saveToPhotos = true
    @Published private(set) var state: ChatSettingsFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ChatSettingsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatSettingsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private let userSettings: UserFlowsStorage & UserCredentialsStorage

    // MARK: - Internal Properties

    weak var delegate: ChatSettingsSceneDelegate?

    // MARK: - Lifecycle

    init(
		userSettings: UserFlowsStorage & UserCredentialsStorage
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

    func send(_ event: ChatSettingsFlow.Event) {
        eventSubject.send(event)
    }

    func clearChats() {
    }

    func deleteChats() {
    }

    func updateSaveToPhotos(item: Bool) {
		userSettings.saveToPhotos = item
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onReserveCopy:
                    self?.delegate?.handleNextScene(.reserveCopy)
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
        saveToPhotos = userSettings.saveToPhotos
    }
}
