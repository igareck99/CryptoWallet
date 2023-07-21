import Foundation

enum AppTransitions: Identifiable, Hashable {
    
    case callView(
        model: P2PCall,
        p2pCallUseCase: P2PCallUseCaseProtocol
    )
    
    // MARK: - Identifiable
    
    var id: String {
        String(describing: self)
    }
    
    // MARK: - Equatable
    
    static func == (lhs: AppTransitions, rhs: AppTransitions) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
