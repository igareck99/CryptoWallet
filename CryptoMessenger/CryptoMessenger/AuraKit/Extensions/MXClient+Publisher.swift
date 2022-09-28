import Combine

// MARK: - MXRestClient ()

extension MXRestClient {

    // MARK: - Internal Methods

    func publicRooms(onServer: String? = nil, limit: UInt? = nil) -> AnyPublisher<MXPublicRoomsResponse, Error> {
        Future<MXPublicRoomsResponse, Error> { promise in
            self.publicRooms(onServer: onServer, limit: limit) { response in
                switch response {
                case .failure(let error):
                    promise(.failure(error))
                case .success(let publicRoomsResponse):
                    promise(.success(publicRoomsResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
}
