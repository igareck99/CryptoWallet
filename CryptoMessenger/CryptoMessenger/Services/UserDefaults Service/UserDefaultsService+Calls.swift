import Combine
import Foundation

protocol UserDefaultsServiceCallable: UserDefaultsServiceProtocol {
	var isCallInprogressExists: Bool { get }
	var inProgressCallSubject: CurrentValueSubject<Bool, Never> { get }
}

// MARK: - UserDefaultsServiceCallable

extension UserDefaultsService: UserDefaultsServiceCallable {
	var isCallInprogressExists: Bool {
		get { bool(forKey: .isCallInprogressExists) }
		set { set(newValue, forKey: .isCallInprogressExists) }
	}
}
