import SwiftUI
import UIKit

protocol AuhtRouterable: View {

    associatedtype Content: View

    var content: () -> Content { get set }

    func showRegistrationScene(delegate: RegistrationSceneDelegate?)

    func showVerificationScene(delegate: VerificationSceneDelegate?)

    func showCountryCodeScene(delegate: CountryCodePickerDelegate)

    func resetState()

    func popToRoot()

}

struct AuhtRouter<Content: View, State: AuthStatable>: View {

    @ObservedObject var state: State

    var content: () -> Content

    var body: some View {
        NavigationStack(path: $state.path) {
            content()
                .sheet(item: $state.presentedItem, content: sheetContent)
                .navigationDestination(for: AuthContentLink.self, destination: linkDestination)
        }
    }

    @ViewBuilder
    private func linkDestination(link: AuthContentLink) -> some View {
        switch link {
            case let .registration(delegate):
                RegistrationConfigurator.build(delegate: delegate)
            case let .verification(delegate):
                VerificationConfigurator.build(delegate: delegate)
            default:
                EmptyView()
        }
    }

    @ViewBuilder
    private func sheetContent(item: AuthSheetLink) -> some View {
        switch item {
            case let .countryCodeScene(delegate):
                CountryCodePicker(delegate: delegate)
            default:
                EmptyView()
        }
    }
}

// MARK: - AuhtRouterable

extension AuhtRouter: AuhtRouterable {

    func showRegistrationScene(delegate: RegistrationSceneDelegate?) {
        state.path.append(
            AuthContentLink.registration(delegate: delegate)
        )
    }

    func showVerificationScene(delegate: VerificationSceneDelegate?) {
        state.path.append(
            AuthContentLink.verification(delegate: delegate)
        )
    }

    func showCountryCodeScene(delegate: CountryCodePickerDelegate) {
        state.presentedItem = AuthSheetLink.countryCodeScene(delegate: delegate)
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
