import SwiftUI

// MARK: - ViewGeneratable

protocol ViewGeneratable: Equatable {

    // MARK: - Types

	associatedtype ViewType: View

	var id: UUID { get }
    
    // MARK: - Internal Methods

	@ViewBuilder
	func view() -> ViewType

    func getItemWidth() -> CGFloat
}
