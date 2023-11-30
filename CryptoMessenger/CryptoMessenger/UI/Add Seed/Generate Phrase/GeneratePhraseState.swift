import Combine
import SwiftUI

protocol GeneratePhraseStatable: ObservableObject {
    var path: NavigationPath { get set }
    var presentedItem: BaseSheetLink? { get set }
}

final class GeneratePhraseState: GeneratePhraseStatable {
    static let shared = GeneratePhraseState()
    @Published var path = NavigationPath()
    @Published var presentedItem: BaseSheetLink?
}
