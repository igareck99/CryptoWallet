import Combine
import UIKit

// MARK: - ContactInfoViewDelegate

protocol ContactInfoViewDelegate: ObservableObject {

    // MARK: - Internal Properties

    var resources: ContactInfoSourcesable.Type { get }

    func onCloseTap()
}

protocol ContactInfoViewModelDelegate: AnyObject {
    func didTapClose()
}

// MARK: - ContactInfoViewModel

final class ContactInfoViewModel: ObservableObject {

    // MARK: - Internal Properties

    let resources: ContactInfoSourcesable.Type
    weak var delegate: ContactInfoViewModelDelegate?

    // MARK: - Lifecycle

    init(
        delegate: ContactInfoViewModelDelegate? = nil,
        resources: ContactInfoSourcesable.Type = ContactInfoResources.self
    ) {
        self.delegate = delegate
        self.resources = resources
    }
}

// MARK: - ContactInfoViewDelegate

extension ContactInfoViewModel: ContactInfoViewDelegate {
    func onCloseTap() {
        delegate?.didTapClose()
    }
}
