import SwiftUI
import Combine

final class SecurityNewViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: SecurityNewSceneDelegate?

    @Published private(set) var state: SecurityNewFlow.ViewState = .idle
    @Published var profileObserveState = ""
    @Published var lastSeenState = ""
    @Published var callsState = ""
    @Published var geopositionState = ""
    @Published var telephoneSeeState = ""

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SecurityNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SecurityNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore
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

    func send(_ event: SecurityNewFlow.Event) {
        eventSubject.send(event)
    }
    
    func updateProfileObserveState(item: String) {
        telephoneSeeState = item
        userCredentialsStorageService.telephoneSeeState = item
    }
    
    func updateLastSeenState(item: String) {
        telephoneSeeState = item
        userCredentialsStorageService.telephoneSeeState = item
    }
    
    func updateCallsState(item: String) {
        telephoneSeeState = item
        userCredentialsStorageService.telephoneSeeState = item
    }
    
    func updateGeopositionState(item: String) {
        telephoneSeeState = item
        userCredentialsStorageService.telephoneSeeState = item
    }
    
    func updateTelephoneState(item: String) {
        telephoneSeeState = item
        userCredentialsStorageService.telephoneSeeState = item
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onBlockList:
                    self?.delegate?.handleNextScene(.blockList)
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
        telephoneSeeState = userCredentialsStorageService.telephoneSeeState
        profileObserveState = userCredentialsStorageService.profileObserveState
        lastSeenState = userCredentialsStorageService.lastSeenState
        callsState = userCredentialsStorageService.callsState
        geopositionState = userCredentialsStorageService.geopositionState
    }
}
