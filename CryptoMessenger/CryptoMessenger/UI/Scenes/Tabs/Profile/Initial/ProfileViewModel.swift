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
    var photos_url_preview: [URL] = []
    var photos_url_original: [URL] = []
    var social_list = ["facebook": "", "VK": "", "twitter": "", "instagram": ""]
}

// MARK: - ProfileViewModel

final class ProfileViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: ProfileSceneDelegate?

    @Published var selectedImage: UIImage?

    // MARK: - Private Properties

    @Published var profile = ProfileItem()
    @Published private(set) var state: ProfileFlow.ViewState = .idle
    @Published private(set) var socialList = SocialListViewModel()
    @Published private(set) var socialListEmpty = true
    @Published private(set) var socialListKeys = ["facebook", "VK", "twitter", "instagram"]
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
        apiClient.publisher(Endpoints.Media.delete_photo([url]))
            .sink(receiveCompletion: { completion in
                switch completion {
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photos_url_preview = self?.profile.photos_url_preview
                    .filter { $0.absoluteString != response[0] } ?? []
                self?.profile.photos_url_original = self?.profile.photos_url_original
                    .filter { $0.absoluteString != response[0]
                        .replacingOccurrences(of: "preview/@", with: "original/@") } ?? []
            })
            .store(in: &subscriptions)
    }

    func add_social(social: [String: String]) {
        apiClient.publisher(Endpoints.Social.set_social(social, user: mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print("Errorepodlp   \(error)")
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.social_list["VK"] = response["vk"] ?? ""
                self?.profile.social_list["instagram"] = response["instagram"] ?? ""
                self?.profile.social_list["twitter"] = response["twitter"] ?? ""
                self?.profile.social_list["facebook"] = response["facebook"] ?? ""
                self?.updateData()
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
                case .aboutApp:
                    self?.delegate?.handleNextScene(.aboutApp)
                case .onChatSettings:
                    self?.delegate?.handleNextScene(.chatSettings)
                case .onFAQ:
                    self?.delegate?.handleNextScene(.FAQ)
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

    private func getPhotos() {
        apiClient.publisher(Endpoints.Media.get_photos(mxStore.getUserId()))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.profile.photos_url_original = []
                self?.profile.photos_url_preview = []
                for x in response {
                    guard let original = x["original"] else { return }
                    guard let preview = x["preview"] else { return }
                    guard let original_url = URL(string: original) else { return }
                    guard let preview_url = URL(string: preview) else { return }
                    self?.profile.photos_url_original.append(original_url)
                    self?.profile.photos_url_preview.append(preview_url)
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
                self?.profile.photos_url_preview.insert(preview_url, at: 0)
                self?.profile.photos_url_original.insert(original_url, at: 0)
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }

    func getSocialList() -> [String: String] {
        state = .idle
        var return_list: [String: String] = [:]
        apiClient.publisher(Endpoints.Social.get_social(mxStore.getUserId()))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    return
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                return_list.updateValue(response["VK"] ?? "",
                                                      forKey: "VK")
                return_list.updateValue(response["instagram"] ?? "",
                                                      forKey: "instagram")
                return_list.updateValue(response["twitter"] ?? "",
                                                      forKey: "twitter")
                return_list.updateValue(response["facebook"] ?? "",
                                                      forKey: "facebook")
                print("ewddmdskldkld    \(return_list)")
            })
            .store(in: &subscriptions)
        return return_list
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
        profile.phone = userCredentialsStorageService.userPhoneNumber
        getPhotos()
        print("fffffdf   \(getSocialList())")
        print("skmsdkjfkjsdfjkdkmfdfmkl    \(profile.social_list)")
        for value in profile.social_list where !value.value.isEmpty {
            socialListEmpty = false
        }
    }
}
