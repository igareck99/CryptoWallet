import SwiftUI
import Combine

final class ChatSettingsViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    @Published var saveToPhotos = false
    @Published private(set) var state: ChatSettingsFlow.ViewState = .idle
    private let eventSubject = PassthroughSubject<ChatSettingsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ChatSettingsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService

    // MARK: - Internal Properties

    weak var delegate: ChatSettingsSceneDelegate?

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

    func send(_ event: ChatSettingsFlow.Event) {
        eventSubject.send(event)
    }

    func clearChats() {
        print("Очистить все чаты")
    }

    func deleteChats() {
        print("Удалить чаты")
    }
    
    func updateSaveToPhotos() {
        saveToPhotos.toggle()
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

    private func updateData() {
        
    }

}
