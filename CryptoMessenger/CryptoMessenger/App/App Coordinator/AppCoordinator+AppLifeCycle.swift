import Foundation

// MARK: - AppDelegateApplicationLifeCycle

extension AppCoordinator: AppDelegateApplicationLifeCycle {

    func applicationWillTerminate() {
    }

    func applicationDidEnterBackground() {
        timeService.saveTimeStamp()
    }

    func applicationWillEnterForeground() {
        updateAppState()
        if userSettings.isLocalAuth {
            start()
        }
    }

    func applicationWillResignActive() {
        timeService.saveTimeStamp()
    }

    func applicationProtectedDataWillBecomeUnavailable() {
    }

    func applicationProtectedDataDidBecomeAvailable() {
    }
}
