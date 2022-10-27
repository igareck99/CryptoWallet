import SwiftUI

protocol ReactionsGroupViewModelProtocol: ObservableObject {

	associatedtype ViewGenerated: ViewGeneratable

	var items: [ViewGenerated] { get }
}

class ReactionsGroupViewModel<GeneratedView: ViewGeneratable>: ObservableObject {

	var items: [GeneratedView]

	init(items: [GeneratedView]) {
		self.items = items
	}
}

// MARK: - ReactionsGroupViewModelProtocol

extension ReactionsGroupViewModel: ReactionsGroupViewModelProtocol { }
