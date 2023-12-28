import UIKit

// MARK: - UIApplication

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addTapGestureRecognizer() {
            guard let window = windows.first else { return }
            let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
            tapGesture.cancelsTouchesInView = false
            tapGesture.delegate = self
            tapGesture.name = "MyTapGesture"
            window.addGestureRecognizer(tapGesture)
        }
}

// MARK: - UIApplication(UIGestureRecognizerDelegate)

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
