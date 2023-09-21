import Foundation

extension MatrixUseCase {
    func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void) {
        matrixService.getDevicesWithActiveSessions(completion: completion)
    }

    func logoutDevices(completion: @escaping EmptyResultBlock) {
        matrixService.getDevicesWithActiveSessions { [weak self] result in
            guard case .success(let userDevices) = result else { return }
            self?.matrixService.remove(userDevices: userDevices, completion: completion)
        }
    }
}
