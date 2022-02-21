import Combine
import SwiftUI

// MARK: - ProfileItem

struct ProfileItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    var avatar: URL?
    var name = "Имя не заполнено"
    var nickname = ""
    var status = "Всем привет! Я использую AURA!"
    var info = ""
    var phone = "Номер не заполнен"
    var photos: [Image] = []
    var photosUrls: [MediaResponse] = []
    var social_list: [String: String] = [:]
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?

    @Published var selectedImage: UIImage?

    // MARK: - Private Properties

    @Published private(set) var profile = ProfileItem()
    @Published private(set) var state: ProfileFlow.ViewState = .idle
    @Published private(set) var socialList = SocialListViewModel()
    @Published private(set) var socialListEmpty = false
    private let eventSubject = PassthroughSubject<ProfileFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ProfileFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    @Injectable private var apiClient: APIClientManager
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

    func send(_ event: ProfileFlow.Event) {
        eventSubject.send(event)
    }

    func deletePhoto(url: String) {
        apiClient.publisher(Endpoints.Media.deletePhoto([url]))
            .sink(receiveCompletion: { completion in
                switch completion {
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photosUrls = self?.profile.photosUrls
                    .filter { $0.photosUrlPreview.absoluteString != response[0] } ?? []
            })
            .store(in: &subscriptions)
    }

    // MARK: - Private Methods

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.updateData()
                    self?.objectWillChange.send()
                case .onProfileScene:
                    self?.delegate?.handleNextScene(.profileDetail)
                case .onPersonalization:
                    self?.delegate?.handleNextScene(.personalization)
                case .onSecurity:
                    self?.delegate?.handleNextScene(.security)
                case .onAboutApp:
                    self?.delegate?.handleNextScene(.aboutApp)
                case .onChatSettings:
                    self?.delegate?.handleNextScene(.chatSettings)
                case .onFAQ:
                    self?.delegate?.handleNextScene(.FAQ)
                case let .onAddPhoto(image):
                    self?.profile.photos.append(Image(uiImage: image))
                }
            }
            .store(in: &subscriptions)

        $selectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let image = image else { return }
                self?.send(.onAddPhoto(image))
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

    private func getPhotos() {
        apiClient.publisher(Endpoints.Media.getPhotos(mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photosUrls = []
                for x in response {
                    guard let original = x["original"] else { return }
                    guard let preview = x["preview"] else { return }
                    guard let original_url = URL(string: original) else { return }
                    guard let preview_url = URL(string: preview) else { return }
                    self?.profile.photosUrls.append(MediaResponse(photosUrlPreview: preview_url, photosUrlOriginal: original_url))
                }
            })
            .store(in: &subscriptions)
    }

    func addPhoto(image: UIImage) {
        guard let data = image.pngData() else { return }
        let multipartData = MultipartFileData(file: "photo",
                                              mimeType: "image/png",
                                              fileData: data)
        apiClient.publisher(Endpoints.Media.upload(multipartData, name: mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let original = response["original"] else { return }
                guard let preview = response["preview"] else { return }
                guard let original_url = URL(string: original) else { return }
                guard let preview_url = URL(string: preview) else { return }
                print("original_url    \(original_url)")
                print("preview_url    \(preview_url)")
                self?.profile.photosUrls.insert(MediaResponse(photosUrlPreview: preview_url, photosUrlOriginal: original_url), at: 0)
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }

    private func getSocialList() {
        state = .idle
        apiClient.publisher(Endpoints.Social.getSocial(mxStore.getUserId()))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.profile.social_list = [:]
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.social_list = response
            })
            .store(in: &subscriptions)
    }

    private func updateData() {
        profile.nickname = mxStore.getUserId()
        if !mxStore.getDisplayName().isEmpty {
            profile.name = mxStore.getDisplayName()
        }
        if !mxStore.getStatus().isEmpty {
            profile.status = mxStore.getStatus()
        }
        if !mxStore.getAvatarUrl().isEmpty {
            profile.avatar = URL(fileURLWithPath: mxStore.getAvatarUrl())
        }
        getPhotos()
        profile.phone = userCredentialsStorageService.userPhoneNumber
        socialList.listData = userCredentialsStorageService.socialNetworkList.filter { $0.type == .show }
        socialListEmpty = userCredentialsStorageService.socialNetworkList.filter { $0.type == .show }.isEmpty
    }
}

// MARK: - MediaResponse

struct MediaResponse: Codable {

    // MARK: - Internal Properties

    var photosUrlPreview: URL
    var photosUrlOriginal: URL

}
