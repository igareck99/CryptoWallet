import SwiftUI

struct CountryCodePicker: UIViewControllerRepresentable {

    weak var delegate: CountryCodePickerDelegate?

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CountryCodePickerViewController(delegate: delegate)
        let navController = UINavigationController(rootViewController: controller)
        return navController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
