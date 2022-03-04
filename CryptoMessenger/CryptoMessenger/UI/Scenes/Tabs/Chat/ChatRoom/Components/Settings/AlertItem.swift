import SwiftUI

// MARK: - AlertItem

struct AlertItem: Identifiable {

    // MARK: - Internal Properties

    let id = UUID()
    let title: Text
    var message: Text?
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button
}
