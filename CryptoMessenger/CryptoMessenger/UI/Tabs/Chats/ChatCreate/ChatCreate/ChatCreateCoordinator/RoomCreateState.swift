import SwiftUI

// MARK: - RoomCreateState

enum RoomCreateState: String {
    case roomCreateError = "Ошибка при создании комнаты"
    case roomAlreadyExist = "Такой чат уже существует"
    case roomCreateSucces = "Комната успешно создана"
    
    
    var color: Color {
        switch self {
        case .roomAlreadyExist:
            return .yellow
        case .roomCreateError:
            return .spanishCrimson
        case .roomCreateSucces:
            return .greenCrayola
        }
    }
}
