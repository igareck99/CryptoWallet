import SwiftUI

// MARK: - TranslateAction
// swiftlint:disable:all
enum TranslateAction: CaseIterable, Identifiable {
    
    // MARK: - Types

    case russian
    case english
    case spagnish
    case italian

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .russian:
            return "Русский"
        case .english:
            return "English"
        case .spagnish:
            return "Spanish"
        case .italian:
            return "Italian"
        }
    }

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
    @Binding var cardPosition: CardPosition

    // MARK: - Private Properties

    @State private var isShown = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            ForEach(TranslateAction.allCases, id: \.id) { act in
                Button(action: {
                    vibrate()
                    action = act
                    cardPosition = .bottom
                }, label: {
                    HStack {
                        HStack {
                            act.image
                        }
                        .frame(width: 40, height: 40)
//                        .background(act.color.suColor.opacity(0.1))
                        .cornerRadius(20)

                        Text(act.title)
                            .font(.regular(17))
//                            .foreground(act == .default ? .red() : .blue())
                            .padding(.leading, 16)

                        Spacer()
                    }
                    .frame(height: 64)
                    .padding([.leading, .trailing], 16)
                })
                .frame(height: 64)
            }
        }
    }
}
