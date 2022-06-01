import SwiftUI

// MARK: - TranslateAction
// swiftlint: disable all
enum TranslateAction: CaseIterable, Identifiable {
    // MARK: - Types

    case russian
    case system
    case english
    case spanish
    case italian
    case french
    case arabic
    case german
    case chinese

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .russian:
            return "Русский язык"
        case .system:
            return "Как в системе"
        case .english:
            return "Английский язык"
        case .spanish:
            return "Испанский язык"
        case .italian:
            return "Итальянский язык"
        case .french:
            return "Француский язык"
        case .arabic:
            return "Арабский язык"
        case .german:
            return "Немецкий язык"
        case .chinese:
            return "中國人"
        }
    }
    
    var languageCode: String {
        switch Locale.preferredLanguages[0] {
        case "ru":
            return "Русский"
        case "en":
            return "English"
        case "es":
            return "Spanish"
        case "it":
            return "Italiano"
        case "fr":
            return "French"
        case "ar":
            return "Arabic"
        case "de":
            return "German"
        case "zh-CN":
            return "Chinese"
        default: break
        }
        return ""
    }
        
    var description: String {
        switch self {
        case .russian:
            return "Russian"
        case .system:
            return "Как в системе \(languageCode)"
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        case .italian:
            return "Italian"
        case .french:
            return "English"
        case .arabic:
            return "Arabic"
        case .german:
            return "German"
        case .chinese:
            return "中國人"
        }
    }
    
    var color: Palette { self == .russian || self == .english ? .red() : .blue() }
    
    var image: Image {
        switch self {
        default:
            return R.image.chat.groupMenu.translate.image
        }
    }
}

// MARK: - TranslateMenuView

struct TranslateMenuView: View {

    // MARK: - Internal Properties

    @Binding var action: TranslateAction?
    @Binding var translateCardPosition: CardPosition

    // MARK: - Private Properties

//    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(TranslateAction.allCases, id: \.id) { act in
                HStack(alignment: .firstTextBaseline) {
                        VStack {
//                            HStack {
//                                act.image
//                            }
//                            .frame(width: 40, height: 40)
//                            .background(act.color.suColor.opacity(0.1))
//                            .cornerRadius(20)
                        }
                    VStack(alignment: .leading) {
                            Text(act.title)
                                .font(.bold(15))
                                .foreground(.black())
                                .padding(.leading, 16)
                            Text(act.description)
                                .font(.regular(13))
                                .foreground(.black())
                                .padding(.leading, 16)
                        }
                        Spacer()
                    }
                    .frame(height: 64)
                    .padding([.leading, .trailing], 16)
                    .onTapGesture {
                        vibrate()
                        action = act
                        translateCardPosition = .bottom
                    }
                }
            }
        }
}
