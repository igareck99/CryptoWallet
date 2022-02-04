import SwiftUI


final class ChatSettingsViewModel: ObservableObject {
    
    // MARK: - Internal Properties

    weak var delegate: ChatSettingsSceneDelegate?
    
    
    
    // MARK: - Internal Methods
    
    func clearChats() {
        print("Очистить все чаты")
    }
    
    func deleteChats() {
        print("Удалить чаты")
    }
    
}
