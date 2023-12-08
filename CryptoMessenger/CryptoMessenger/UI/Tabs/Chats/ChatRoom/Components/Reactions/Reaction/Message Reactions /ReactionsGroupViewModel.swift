import SwiftUI

// MARK: - ReactionsGroupViewModelProtocol

protocol ReactionsGroupViewModelProtocol: ObservableObject {

	associatedtype ViewGenerated: ViewGeneratable

	var items: [ViewGenerated] { get }
}

// MARK: - ReactionsGroupViewModel

class ReactionsGroupViewModel<GeneratedView: ViewGeneratable>: ObservableObject {

	var items: [GeneratedView]

	init(items: [GeneratedView]) {
		self.items = items
	}
}

// MARK: - ReactionsGroupViewModelProtocol

extension ReactionsGroupViewModel: ReactionsGroupViewModelProtocol { }
