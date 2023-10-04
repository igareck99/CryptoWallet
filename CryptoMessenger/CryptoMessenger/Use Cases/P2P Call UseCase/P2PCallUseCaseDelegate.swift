import Foundation

protocol P2PCallUseCaseDelegate: AnyObject {
    func callDidChange(state: P2PCallState)
}
