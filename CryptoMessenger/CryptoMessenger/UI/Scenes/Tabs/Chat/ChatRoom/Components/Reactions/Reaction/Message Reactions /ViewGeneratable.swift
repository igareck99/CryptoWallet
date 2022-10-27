import SwiftUI

protocol ViewGeneratable {

	associatedtype ViewType: View

	var id: UUID { get }

	@ViewBuilder
	func view() -> ViewType
}
