import Foundation

protocol GroupCallsViewModelProtocol {  }

final class GroupCallsViewModel {
	
	private let jitsiService: JitsiServiceProtocol

	init(
		jitsiService: JitsiServiceProtocol
	) {
		self.jitsiService = jitsiService
	}
}
