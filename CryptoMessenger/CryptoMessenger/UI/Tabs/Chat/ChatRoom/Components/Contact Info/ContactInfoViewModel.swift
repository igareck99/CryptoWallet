import Combine
import UIKit

// MARK: - ContactInfoViewModel

final class ContactInfoViewModel: ObservableObject, ContactInfoViewDelegate {
    
    // MARK: - Internal Properties

    let resources: ContactInfoSourcesable.Type
    
    // MARK: - Lifecycle

    init(
        resources: ContactInfoSourcesable.Type = ContactInfoResources.self
    ) {
        self.resources = resources
    }
}

// MARK: - ContactInfoViewDelegate

protocol ContactInfoViewDelegate: ObservableObject {
    
    // MARK: - Internal Properties

    var resources: ContactInfoSourcesable.Type { get }

}
