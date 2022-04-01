import Foundation

// MARK: - Endpoints

enum Endpoints {

    // MARK: - Registration

    enum Registration {

        // MARK: - Static Methods

        static func sms(_ phone: String) -> Endpoint<String> {
            Endpoint<String>(method: .get, path: "/user/\(phone)/sms")
        }

        static func auth(_ payload: AuthData) -> Endpoint<AuthResponse> {
            let endpoint = Endpoint<AuthResponse>(method: .post, path: "/user/auth")
            endpoint.modifyRequest { $0.jsonBody(payload) }
            return endpoint
        }
    }

    // MARK: - Logout

    enum Session {

        // MARK: - Static Methods

        static func refresh(_ token: String) -> Endpoint<AuthResponse> {
            let endpoint = Endpoint<AuthResponse>(method: .post, path: "/user/refresh")
            endpoint.modifyRequest { $0.jsonBody(dict: ["refresh_token": token]) }
            return endpoint
        }

        static func logout() -> Endpoint<EmptyResponse> {
            Endpoint<EmptyResponse>(method: .post, path: "/mobile/auth/logout")
        }
    }

    // MARK: - Profile

    enum Profile {

        // MARK: - Static Methods

        static func status(_ text: String) -> Endpoint<[String: String]> {
            let endpoint = Endpoint<[String: String]>(method: .post, path: "/profile/description")
            endpoint.modifyRequest { $0.jsonBody(dict: ["description": text]) }
            endpoint.modifyRequest { $0.addHeader("user", value: UserCredentialsStorageService().userId) }
            return endpoint
        }
    }

    // MARK: - Users

    enum Users {

        // MARK: - Static Methods

        static func users(_ phones: [String]) -> Endpoint<[String: String]> {
            let endpoint = Endpoint<[String: String]>(method: .post, path: "/user/list")
            endpoint.modifyRequest { $0.jsonBody(array: phones) }
            return endpoint
        }
    }

    // MARK: - Media

    enum Media {
        static func upload(_ payload: MultipartFileData, name: String) -> Endpoint<MediaResponse> {
            let endpoint = Endpoint<MediaResponse>(method: .post, path: "/profile/media")
            endpoint.modifyRequest { $0.multipartBody(payload) }
            return endpoint
        }

        static func getPhotos(_ name: String) -> Endpoint<[MediaResponse]> {
            let endpoint = Endpoint<[MediaResponse]>(method: .get, path: "/profile/\(name)/media")
            return endpoint
        }

        static func deletePhoto(_ photoUrl: [String]) -> Endpoint<[String]> {
            let endpoint = Endpoint<[String]>(method: .post, path: "/profile/media/delete")
            endpoint.modifyRequest { $0.jsonBody(array: photoUrl) }
            return endpoint
        }
    }

    // MARK: - Social

    enum Social {
        static func getSocial(_ name: String) -> Endpoint<[SocialResponse]> {
            Endpoint<[SocialResponse]>(method: .get, path: "/profile/\(name)/social")
        }

        static func setSocialNew(_ payload: [SocialResponse],
                                 user: String) -> Endpoint<[SocialResponse]> {
            let endpoint = Endpoint<[SocialResponse]>(method: .patch, path: "/profile/social")
            endpoint.modifyRequest { $0.jsonBody(payload) }
            endpoint.modifyRequest { $0.addHeader("user", value: user) }
            return endpoint
        }
    }
}
