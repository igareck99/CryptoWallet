import Foundation

protocol AppDelegateApplicationLifeCycle {
    
    func applicationWillTerminate()
    
    func applicationDidEnterBackground()
    
    func applicationWillEnterForeground()
    
    func applicationWillResignActive()
    
    func applicationProtectedDataWillBecomeUnavailable()
    
    func applicationProtectedDataDidBecomeAvailable()
}
