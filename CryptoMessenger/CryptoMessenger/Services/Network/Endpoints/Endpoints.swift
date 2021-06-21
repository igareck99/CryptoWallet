import Foundation

// MARK: - Endpoints

enum Endpoints {

    // MARK: - Types

    enum RelationshipType {
        static func get() -> Endpoint<RelationshipResponse> {
            let endpoint = Endpoint<RelationshipResponse>(
                method: .get,
                path: "/templates/relationship-types"
            )
            return endpoint
        }
    }

    enum Occasions {
        static func get() -> Endpoint<OccasionResponse> {
            let endpoint = Endpoint<OccasionResponse>(
                method: .get,
                path: "/templates/occasions"
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
