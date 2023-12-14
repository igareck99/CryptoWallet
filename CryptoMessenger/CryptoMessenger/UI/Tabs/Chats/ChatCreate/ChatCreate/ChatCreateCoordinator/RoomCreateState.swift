import SwiftUI

// MARK: - RoomCreateState

enum RoomCreateState {
    case roomCreateError
    case roomAlreadyExist
    case roomCreateSucces
    
    
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

    var text: String {
        switch self {
        case .roomCreateError:
            return "Ошибка при создании комнаты"
        case .roomAlreadyExist:
            return "Такой чат уже существует"
        case .roomCreateSucces:
            return "Комната успешно создана"
        }
    }
}
