import Foundation
import MatrixSDK

protocol GroupCallsViewModelProtocol {  }

final class GroupCallsViewModel {
	
	private let jitsiService: JitsiServiceProtocol

	init(
		jitsiService: JitsiServiceProtocol
	) {
		self.jitsiService = jitsiService
	}
}
