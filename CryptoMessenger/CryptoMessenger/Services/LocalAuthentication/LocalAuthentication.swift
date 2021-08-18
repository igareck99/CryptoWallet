import Foundation
import LocalAuthentication
import UIKit

protocol LocalAuthenticationDelegate: AnyObject {
    func didFinish()
}

final class LocalAuthentication {
    weak var delegate: LocalAuthenticationDelegate?

    // MARK: - Internal Methods
    func useBiometrics() {
        print("Func was called")
        let myContext = LAContext()
        let myLocalizedReasonString = " "
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         localizedReason: myLocalizedReasonString) { success, evaluateError in
                    DispatchQueue.main.async {
                        if success {
                            print("Awesome!!... User authenticated successfully")
                            print(evaluateError ?? " ")
                        } else {
                            print("Sorry!!... User did not authenticate successfully")
                        }
                    }
                }
            } else {
                print("Sorry!!.. Could not evaluate policy.")
            }
        } else {
            print("Ooops!!.. This feature is not supported.")
        }

    }
}
