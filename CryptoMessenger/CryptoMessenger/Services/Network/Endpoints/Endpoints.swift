import Foundation

// MARK: - Endpoints

enum Endpoints {

    // MARK: - Types

    enum Registration {
        static func get(_ phone: String) -> Endpoint<EmptyResponse> {
            let endpoint = Endpoint<EmptyResponse>(
                method: .get,
                path: "/api/sms?phone=\(phone)"
            )
            return endpoint
        }
    }

    enum Logout {
        static func post() -> Endpoint<EmptyResponse> {
            return Endpoint<EmptyResponse>(method: .post, path: "/mobile/auth/logout")
        }
    }

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
