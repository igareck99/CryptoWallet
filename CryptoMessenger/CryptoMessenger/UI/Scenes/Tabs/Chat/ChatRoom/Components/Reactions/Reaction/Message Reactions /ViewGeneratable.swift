import SwiftUI

protocol ViewGeneratable: Equatable {

	associatedtype ViewType: View

	var id: UUID { get }

	@ViewBuilder
	func view() -> ViewType
}
