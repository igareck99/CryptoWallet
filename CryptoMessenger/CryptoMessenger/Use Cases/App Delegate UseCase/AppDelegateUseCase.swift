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
    private let privateDataCleaner: PrivateDataCleanerProtocol
	private let userSettings: UserFlowsStorage
	private let timeService: TimeServiceProtocol.Type

	init(
        appCoordinator: Coordinator & AppCoordinatorProtocol,
        keychainService: KeychainServiceProtocol,
        privateDataCleaner: PrivateDataCleanerProtocol,
        userSettings: UserFlowsStorage,
        timeService: TimeServiceProtocol.Type
    ) {
		self.appCoordinator = appCoordinator
		self.keychainService = keychainService
        self.privateDataCleaner = privateDataCleaner
		self.userSettings = userSettings
		self.timeService = timeService
	}

	private func updateAppState() {
		guard
			keychainService.isPinCodeEnabled == true,
			let lastTimeInterval = keychainService.double(forKey: .gmtZeroTimeInterval),
			lastTimeInterval != .zero
		else {
			return
		}

		let currenttimeInterval = timeService.getTimeStampUTCZero() ?? .zero
		let diffTimeInterval = currenttimeInterval - lastTimeInterval

		// Если приложение 30 минут в бэкграунде, то перезапрашиваем пин
		userSettings.isLocalAuth = diffTimeInterval.minutes >= 30
	}

	private func saveTimeStamp() {
		let timeInterval = timeService.getTimeStampUTCZero() ?? .zero
		keychainService.set(timeInterval, forKey: .gmtZeroTimeInterval)
	}
}

// MARK: - AppDelegateUseCaseProtocol

extension AppDelegateUseCase: AppDelegateUseCaseProtocol {
	func start() {
		if userSettings[.isAppNotFirstStart] == false {
            privateDataCleaner.resetPrivateData()
			keychainService.isPinCodeEnabled = true
		}
		userSettings[.isAppNotFirstStart] = true
		userSettings.isLocalAuth = keychainService.isPinCodeEnabled == true
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
