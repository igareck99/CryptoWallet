import SwiftUI
import UIKit

protocol AuhtRouterable: View {

    associatedtype Content: View

    var content: () -> Content { get }

    func showRegistrationScene(delegate: RegistrationSceneDelegate?)

    func showVerificationScene(delegate: VerificationSceneDelegate?)

    func showCountryCodeScene(delegate: CountryCodePickerDelegate)

    func resetState()

    func popToRoot()

}

struct AuhtRouter<
    Content: View,
    State: AuthStatable,
    Factory: ViewsBaseFactoryProtocol
>: View {

    @ObservedObject var state: State
    let factory: Factory.Type
    let content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(
                    item: $state.presentedItem,
                    content: factory.makeSheet
                )
                .navigationDestination(
                    for: BaseContentLink.self,
                    destination: factory.makeContent
                )
        }
    }
}

// MARK: - AuhtRouterable

extension AuhtRouter: AuhtRouterable {

    func showRegistrationScene(delegate: RegistrationSceneDelegate?) {
        state.path.append(
            BaseContentLink.registration(delegate: delegate)
        )
    }

    func showVerificationScene(delegate: VerificationSceneDelegate?) {
        state.path.append(
            BaseContentLink.verification(delegate: delegate)
        )
    }

    func showCountryCodeScene(delegate: CountryCodePickerDelegate) {
        state.presentedItem = BaseSheetLink.countryCodeScene(delegate: delegate)
    }

    func popToRoot() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }
    
    func resetState() {
        state.path = NavigationPath()
        state.presentedItem = nil
    }
}
