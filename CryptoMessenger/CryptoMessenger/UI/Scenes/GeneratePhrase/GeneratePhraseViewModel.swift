import SwiftUI

// MARK: - GeneratePhraseViewModel

final class GeneratePhraseViewModel: ObservableObject {

    // MARK: - Internal Properties

    weak var delegate: GeneratePhraseSceneDelegate?
    @Published var generatePhraseState: GeneratePhraseState = .generate
    @Published var generatedKey = "symbol riot impact error error  design leave opera snap lava"

    // MARK: - Internal Methods

    func toggleState(_ state: ButtonGeneratePhraseState) {
        if generatePhraseState == .generate {
            withAnimation(.easeInOut(duration: 0.5), {
                generatePhraseState = .warning
            })
        } else if generatePhraseState == .warning {
            if state == .create {
                generatePhraseState = .watchKey
            }
        }
        self.objectWillChange.send()
    }
}

// MARK: - GeneratePhraseState

enum GeneratePhraseState {

    case generate
    case warning
    case watchKey
}

// MARK: - GeneratePhraseState

enum ButtonGeneratePhraseState {

    case create
    case importing
}
