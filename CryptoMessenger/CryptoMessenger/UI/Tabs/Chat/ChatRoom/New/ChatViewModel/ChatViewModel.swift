import Combine
import SwiftUI

// MARK: - ChatViewModel

final internal class ChatViewModel: ObservableObject, ChatViewModelProtocol {

    @Published var displayItems = [any ViewGeneratable]()
    @Published var inputText = ""
    @Published var activeEditMessage: RoomEvent?
    @Published var quickAction: QuickActionCurrentUser?
    @Published private(set) var room: AuraRoomData
    @Published var isAccessToWrite = true
    var sources: ChatRoomSourcesable.Type = ChatRoomResources.self
    var coordinator: ChatHistoryFlowCoordinatorProtocol
    let p2pCallsUseCase: P2PCallUseCaseProtocol
    let mediaService = MediaService()
    @Injectable var matrixUseCase: MatrixUseCaseProtocol
    @Published var eventSubject = PassthroughSubject<ChatRoomFlow.Event, Never>()

    // MARK: - Private Properties

    @Published private(set) var state: ChatRoomFlow.ViewState = .idle
    private let stateValueSubject = CurrentValueSubject<ChatRoomFlow.ViewState, Never>(.idle)
    private let factory: RoomEventsFactory.Type
    private var subscriptions = Set<AnyCancellable>()
    private let channelFactory: ChannelUsersFactoryProtocol.Type
    private var roomPowerLevels: MXRoomPowerLevels?
    @Published private var outputMessages: [RoomEvent] = []

    // MARK: - To replace
    @Published var location = Place(name: "", latitude: 0, longitude: 0)
    @Published var isSendLocation = false
    @Published var chatData = ChatData.emptyObject()

    init(
        room: AuraRoomData,
        coordinator: ChatHistoryFlowCoordinatorProtocol,
        factory: RoomEventsFactory.Type = RoomEventsFactory.self,
        channelFactory: ChannelUsersFactoryProtocol.Type = ChannelUsersFactory.self,
        p2pCallsUseCase: P2PCallUseCaseProtocol = P2PCallUseCase.shared
    ) {
        self.room = room
        self.coordinator = coordinator
        self.channelFactory = channelFactory
        self.factory = factory
        self.p2pCallsUseCase = p2pCallsUseCase
        bindInput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    private func bindInput() {
        eventSubject
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .onAppear:
                    self.matrixUseCase.getRoomState(roomId: self.room.roomId) { [weak self] result in
                        guard let self = self else { return }
                        guard case let .success(state) = result else { return }
                        self.roomPowerLevels = state.powerLevels
                        self.isAccessToWrite = state.powerLevels.powerLevelOfUser(withUserID: self.matrixUseCase.getUserId()) >= 50 ? true : false
                        self.matrixUseCase.objectChangePublisher.send()
                    }
                default:
                    break
                }
            }
            .store(in: &subscriptions)

        matrixUseCase.objectChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let room = self.matrixUseCase.auraRooms.first(where: { $0.roomId == self.room.roomId })
                else {
                    return
                }
                self.displayItems = self.factory.makeEventView(
                    events: room.events,
                    delegate: self,
                    onLongPressMessage: { event in
                    self.onLongPressMessage(event)
                }, onReactionTap: { reaction in
                    self.onRemoveReaction(reaction)
                })
            }
            .store(in: &subscriptions)
    }

    func showChatRoomMenu() {
        self.coordinator.chatMenu({ result in
            switch result {
            case .media:
                self.coordinator.galleryPickerSheet(sourceType: .photoLibrary,
                                                    galleryContent: .all) { image in
                    guard let image = image else { return }
                    self.sendPhoto(image)
                } onSelectVideo: { url in
                    guard let url = url else { return }
                    self.makeOutputEventView(.video(url))
                    self.sendVideo(url)
                }
            case .contact:
                self.coordinator.showSelectContact(mode: .send,
                                                   chatData: Binding(get: {
                                                       self.chatData
                                                   }, set: { value in
                                                       self.chatData = value
                                                   }),
                                                   contactsLimit: 1) { contacts in
                    contacts.map {
                        self.makeOutputEventView(.contact(name: $0.name, phone: $0.phone, url: nil))
                        self.sendContact($0)
                    }
                }
            case .document:
                self.coordinator.presentDocumentPicker(onCancel: {
                    self.coordinator.dismissCurrentSheet()
                }, onDocumentsPicked: { url in
                    url.map {
                        self.makeOutputEventView(.file("", $0))
                        self.sendFile($0)
                    }
                })
            case .location:
                self.coordinator.presentLocationPicker(
                    place: Binding(get: {
                        self.location
                    }, set: { value in
                        self.location = value ?? Place(name: "", latitude: 0, longitude: 0)
                    }),
                    sendLocation: Binding(get: {
                        self.isSendLocation
                    }, set: { value in
                        self.isSendLocation = value
                    }), onSendPlace: { place in
                        let data = LocationData(lat: place.latitude,
                                                long: place.longitude)
                        self.makeOutputEventView(.location((lat: data.lat, long: data.long)))
                        self.sendMap(data)
                    })
            default:
                break
            }
        }, {
            self.coordinator.galleryPickerSheet(sourceType: .camera,
                                                galleryContent: .all) { image in
                guard let image = image else { return }
                self.sendPhoto(image)
            } onSelectVideo: { url in
                guard let url = url else { return }
                self.makeOutputEventView(.video(url))
                self.sendVideo(url)
            }
        }, { image in
            self.sendPhoto(image)
            self.coordinator.dismissCurrentSheet()
        })
    }

    func sendText() {
        switch quickAction {
        case .reply:
            guard let activeEditMessage = activeEditMessage else { return }
            self.makeOutputEventView(.text(inputText), true)
            matrixUseCase.sendReply(activeEditMessage, inputText)
            self.matrixUseCase.objectChangePublisher.send()
        case .edit:
            guard let activeEditMessage = activeEditMessage else { return }
            matrixUseCase.edit(roomId: room.roomId, text: inputText,
                               eventId: activeEditMessage.eventId)
            self.matrixUseCase.objectChangePublisher.send()
        default:
            self.makeOutputEventView(.text(inputText))
            matrixUseCase.sendText(room.roomId,
                                   inputText,
                                   completion: { _ in
                self.inputText = ""
                self.matrixUseCase.objectChangePublisher.send()
            })
        }
        activeEditMessage = nil
        quickAction = nil
        self.inputText = ""
    }

    private func onLongPressMessage(_ event: RoomEvent) {
        let role = channelFactory.detectUserRole(userId: event.sender,
                                                 roomPowerLevels: roomPowerLevels)
        coordinator.messageReactions(event.isFromCurrentUser,
                                     room.isChannel,
                                     role, { action in
            withAnimation(.easeIn(duration: 0.25)) {
                self.activeEditMessage = event
                self.quickAction = action
                self.coordinator.dismissCurrentSheet()
            }
            debugPrint("Message Action  \(action)")
        }, { reaction in
            self.coordinator.dismissCurrentSheet()
            self.matrixUseCase.react(eventId: event.eventId,
                                     roomId: self.room.roomId,
                                     emoji: reaction)
            self.matrixUseCase.objectChangePublisher.send()
        })
    }
    
    private func makeOutputEventView(_ type: MessageType,
                                     _ isReply: Bool = false) {
        let sender = matrixUseCase.getUserId()
        let event = factory.makeChatOutputEvent(type, room.roomId,
                                                sender,
                                                matrixUseCase.fromCurrentSender(sender),
                                                isReply)
        guard let view = factory.makeEventView(events: [event], delegate: self, onLongPressMessage: { _ in
        }, onReactionTap: { _ in  }).first else { return }
        displayItems.append(view)
    }
    
    private func onRemoveReaction(_ event: ReactionNewEvent) {
        guard let userId = event.sendersIds.first(where: { $0 == matrixUseCase.getUserId() }) else { return }
        matrixUseCase.removeReaction(roomId: room.roomId,
                                     text: event.emoji,
                                     eventId: event.relatedEvent) { _ in
            self.matrixUseCase.objectChangePublisher.send()
        }
    }
}
