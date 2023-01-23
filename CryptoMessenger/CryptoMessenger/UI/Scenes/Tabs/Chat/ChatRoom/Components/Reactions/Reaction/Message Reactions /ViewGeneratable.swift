import SwiftUI

// MARK: - ViewGeneratable

protocol ViewGeneratable: Equatable, Hashable, Identifiable {

    // MARK: - Types

	var id: UUID { get }
    
    // MARK: - Internal Methods

	@ViewBuilder
	func view() -> AnyView

    func getItemWidth() -> CGFloat
}

// MARK: - Default Impl

extension ViewGeneratable {

	func getItemWidth() -> CGFloat {
		.zero
	}

	// MARK: - Hashable

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	// MARK: - Equatable

	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.id == rhs.id
	}
}
