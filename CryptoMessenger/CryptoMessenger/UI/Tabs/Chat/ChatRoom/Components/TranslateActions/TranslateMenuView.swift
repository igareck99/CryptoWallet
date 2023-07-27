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
            return R.string.localizable.translateRussianLanguage()
        case .system:
            return R.string.localizable.translateSystemLanguage()
        case .english:
            return R.string.localizable.translateEnglishLanguage()
        case .spanish:
            return R.string.localizable.translateSpanishLanguage()
        case .italian:
            return R.string.localizable.translateItalianLanguage()
        case .french:
            return R.string.localizable.translateFrenchLanguage()
        case .arabic:
            return R.string.localizable.translateArabicLangauge()
        case .german:
            return R.string.localizable.translateGermanLanguage()
        case .chinese:
            return R.string.localizable.translateChineseLanguage()
        }
    }
    
    var languageCode: String {
        switch Locale.preferredLanguages[0] {
        case kLanguageRussian:
            return R.string.localizable.translateRussian()
        case kLanguageEnglish:
            return R.string.localizable.translateEnglish()
        case kLanguageSpanish:
            return R.string.localizable.translateSpanish()
        case kLanguageItalian:
            return R.string.localizable.translateItalian()
        case kLanguageFrench:
            return R.string.localizable.translateFrench()
        case kLanguageArabic:
            return R.string.localizable.translateArabic()
        case kLanguageGerman:
            return R.string.localizable.translateGerman()
        case kLanguageChinese:
            return R.string.localizable.translateChinese()
        default: break
        }
        return ""
    }
        
    var description: String {
        switch self {
        case .russian:
            return R.string.localizable.translateRussian()
        case .system:
            return "\(R.string.localizable.translateSystemLanguage()) \(languageCode)"
        case .english:
            return R.string.localizable.translateEnglish()
        case .spanish:
            return R.string.localizable.translateSpanish()
        case .italian:
            return R.string.localizable.translateItalian()
        case .french:
            return R.string.localizable.translateFrench()
        case .arabic:
            return R.string.localizable.translateArabic()
        case .german:
            return R.string.localizable.translateGerman()
        case .chinese:
            return R.string.localizable.translateChinese()
        }
    }
    
    var color: Color { self == .russian || self == .english ? .spanishCrimson : .dodgerTransBlue }
    
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

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(TranslateAction.allCases, id: \.id) { act in
                HStack(alignment: .firstTextBaseline) {
                        VStack {
                            // TODO: Использовать в качестве шаблона для чекмарка
//                            HStack {
//                                act.image
//                            }
//                            .frame(width: 40, height: 40)
//                            .background(act.color.suColor.opacity(0.1))
//                            .cornerRadius(20)
                        }
                    VStack(alignment: .leading) {
                            Text(act.title)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.chineseBlack)
                                .padding(.leading, 16)
                            Text(act.description)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.chineseBlack)
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
