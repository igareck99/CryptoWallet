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

    enum Logout {
        static func post() -> Endpoint<EmptyResponse> {
            return Endpoint<EmptyResponse>(method: .post, path: "/mobile/auth/logout")
        }
    }

    // MARK: - Media

    enum Media {
        static func upload(_ payload: MultipartFileData) -> Endpoint<String> {
            let endpoint = Endpoint<String>(method: .post, path: "/media")
            endpoint.modifyRequest {
                $0.multipartBody(payload)
            }
            return endpoint
        }
    }
}
