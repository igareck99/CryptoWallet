import Foundation

protocol AppDelegateUseCaseProtocol: AppDelegateApplicationLifeCycle {
	func start()
}

protocol AppDelegateApplicationLifeCycle {

	func applicationWillTerminate()

	func applicationDidEnterBackground()

	func applicationWillEnterForeground()

	func applicationWillResignActive()

	func applicationProtectedDataWillBecomeUnavailable()

	func applicationProtectedDataDidBecomeAvailable()
}

final class AppDelegateUseCase {

	private let appCoordinator: Coordinator & AppCoordinatorProtocol
	private let keychainService: KeychainServiceProtocol
	private let userSettings: UserFlowsStorage
	private let timeService: TimeServiceProtocol.Type

	init(
		appCoordinator: Coordinator & AppCoordinatorProtocol,
		keychainService: KeychainServiceProtocol,
		userSettings: UserFlowsStorage,
		timeService: TimeServiceProtocol.Type
	) {
		self.appCoordinator = appCoordinator
		self.keychainService = keychainService
		self.userSettings = userSettings
		self.timeService = timeService
	}

	private func updateAppState() {
		guard
			let lastTimeInterval = keychainService.double(forKey: .gmtZeroTimeInterval),
			lastTimeInterval != .zero
		else {
			userSettings.isLocalAuth = true
			return
		}

		let currenttimeInterval = timeService.getTimeStampUTCZero() ?? .zero
		let diffTimeInterval = currenttimeInterval - lastTimeInterval

		// Если приложение 30 минут в бэкграунде, то перезапрашиваем пин
		if diffTimeInterval.minutes >= 30 {
			userSettings.isLocalAuth = true
		}
	}

	private func saveTimeStamp() {
		let timeInterval = timeService.getTimeStampUTCZero() ?? .zero
		keychainService.set(timeInterval, forKey: .gmtZeroTimeInterval)
	}
}

// MARK: - AppDelegateUseCaseProtocol

extension AppDelegateUseCase: AppDelegateUseCaseProtocol {
	func start() {
		userSettings.isLocalAuth = true
		appCoordinator.start()
	}
}

// MARK: - AppDelegateApplicationLifeCycle

extension AppDelegateUseCase: AppDelegateApplicationLifeCycle {

	func applicationWillTerminate() {
		debugPrint("life_cycle: applicationWillTerminate")
	}

	func applicationDidEnterBackground() {
		debugPrint("life_cycle: applicationDidEnterBackground")
		saveTimeStamp()
	}

	func applicationWillEnterForeground() {
		debugPrint("life_cycle: applicationWillEnterForeground")
		updateAppState()
		if userSettings.isLocalAuth {
			appCoordinator.start()
		}
	}

	func applicationWillResignActive() {
		debugPrint("life_cycle: applicationWillResignActive")
		saveTimeStamp()
	}

	func applicationProtectedDataWillBecomeUnavailable() {
		debugPrint("life_cycle: applicationProtectedDataWillBecomeUnavailable")
	}

	func applicationProtectedDataDidBecomeAvailable() {
		debugPrint("life_cycle: applicationProtectedDataDidBecomeAvailable")
	}
}
