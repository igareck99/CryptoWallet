import Combine
import UIKit

// MARK: - ContactInfoViewModel

final class ContactInfoViewModel: ObservableObject, ContactInfoViewDelegate {
    
    // MARK: - Internal Properties

    let sources: ContactInfoSourcesable.Type
    
    // MARK: - Lifecycle

    init(
        sources: ContactInfoSourcesable.Type = ContactInfoResources.self
    ) {
        self.sources = sources
    }
}

// MARK: - ContactInfoViewDelegate

protocol ContactInfoViewDelegate: ObservableObject {
    
    // MARK: - Internal Properties

    var sources: ContactInfoSourcesable.Type { get }

}
