import Combine
import Foundation

// MARK: - NotesViewModel

final class NotesViewModel: ObservableObject {
    
    // MARK: - Internal Properties
    
    let userId: String
    @Published var newKey = ""
    @Published var isKeyNotExist = false
    var notes: [String: String] = [:]
    var buttonState: Bool {
        if !isKeyNotExist || !newKey.isEmpty {
            return false
        }
        return true
    }

    // MARK: - Internal Properties

    private let userDefaults: UserDefaultsService

    // MARK: - Lifecycle

    init(userId: String,
         userDefaults: UserDefaultsService = UserDefaultsService.shared) {
        self.userId = userId
        self.userDefaults = userDefaults
        getUserNote()
    }
    
    // MARK: - Internal Methods
    
    func setUserNote() {
        notes[userId] = newKey
        userDefaults.set(notes, forKey: .userNotes)
    }
    
    // MARK: - Private Methods
    
    private func getUserNote() {
        guard let result = userDefaults.dict(forKey: .userNotes) as? [String: String] else { return }
        notes = result
        newKey = result[userId] ?? ""
        isKeyNotExist = newKey.isEmpty
    }
}
