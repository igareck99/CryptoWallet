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
    @Published var isPinCodeOn = false

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SecurityNewFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SecurityNewFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private(set) var mxStore: MatrixStore
    @Injectable private var userCredentialsStorageService: UserCredentialsStorageService
    @Injectable private var userFlows: UserFlowsStorageService

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
        profileObserveState = item
        userCredentialsStorageService.profileObserveState = item
    }

    func updateLastSeenState(item: String) {
        lastSeenState = item
        userCredentialsStorageService.lastSeenState = item
    }

    func updateCallsState(item: String) {
        callsState = item
        userCredentialsStorageService.callsState = item
    }

    func updateGeopositionState(item: String) {
        geopositionState = item
        userCredentialsStorageService.geopositionState = item
    }

    func updateTelephoneState(item: String) {
        telephoneSeeState = item
        userCredentialsStorageService.telephoneSeeState = item
    }

    func updateIsPinCodeOn() {
        if isPinCodeOn {
            userFlows.isPinCodeOn = false
            isPinCodeOn = false
        } else {
            userFlows.isPinCodeOn = true
            isPinCodeOn = true
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
                case .onBlockList:
                    self?.delegate?.handleNextScene(.blockList)
                case .onCreatePassword:
                    self?.delegate?.handleNextScene(.pinCodeCreate)
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
        isPinCodeOn = userFlows.isPinCodeOn
        profileObserveState = userCredentialsStorageService.profileObserveState
        lastSeenState = userCredentialsStorageService.lastSeenState
        callsState = userCredentialsStorageService.callsState
        geopositionState = userCredentialsStorageService.geopositionState
        telephoneSeeState = userCredentialsStorageService.telephoneSeeState
    }
}
