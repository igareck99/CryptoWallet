import Foundation

// MARK: - Devices

extension MatrixService {

	func getDeviceSession(by deviceId: String, completion: @escaping (EmptyResult) -> Void) {
		// TODO: Нужно проверить на необхоимость auth parameters (в element есть проверка и добавлние auth parameters)
		client?.getSession(toDeleteDevice: deviceId) { res in
			switch res {
			case .success:
				debugPrint("Succeeded GET device session with ID: " + deviceId)
				completion(.success)
			case .failure:
				debugPrint("Failed GET device session with ID: " + deviceId)
				completion(.failure)
			}
		}
	}

	func removeDevice(by deviceId: String, completion: @escaping (EmptyResult) -> Void) {
		// TODO: Нужно проверить на необхоимость auth parameters (в element есть проверка и добавлние auth parameters)
		client?.deleteDevice(deviceId, authParameters: [:]) { response in
			switch response {
			case .success:
				debugPrint("Succeeded REMOVE device with ID: " + deviceId)
				completion(.success)
			case .failure:
				debugPrint("Failed REMOVE device with ID: " + deviceId)
				completion(.failure)
			}
		}
	}

	func getDevicesWithActiveSessions(completion: @escaping (Result<[MXDevice], Error>) -> Void) {
		client?.devices { response in
			switch response {
			case let .success(devices):
				completion(.success(devices))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func remove(userDevices: [MXDevice], completion: @escaping (EmptyResult) -> Void) {
		userDevices.forEach { [weak self] userDevice in
			self?.deviceRemovalGroup.enter()
			self?.removeDevice(by: userDevice.deviceId ) { result in
				switch result {
				case .success:
					debugPrint("Succeeded REMOVE device with ID: " + userDevice.deviceId)
				case .failure:
					debugPrint("Failed REMOVE device with ID: " + userDevice.deviceId)
				}
				self?.deviceRemovalGroup.leave()
			}
		}
		deviceRemovalGroup.notify(queue: .main) { [weak self] in
			self?.loginState = .loggedOut
			self?.logout { result in
				switch result {
				case .failure:
					self?.loginState = .loggedOut
					completion(.failure)
				case .success(let state):
					self?.loginState = state
					completion(.success)
				}
			}
		}
	}
}
