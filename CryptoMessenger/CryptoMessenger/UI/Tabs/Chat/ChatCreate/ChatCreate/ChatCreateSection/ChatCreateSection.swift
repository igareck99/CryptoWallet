import SwiftUI

// MARK: - ChatCreateSection

struct ChatCreateSection: Identifiable, ViewGeneratable {

    var id = UUID()
    let data: ChatCreateSectionCases
    let views: [any ViewGeneratable]

    // MARK: - Lifecycle

    init(data: ChatCreateSectionCases,
         views: [any ViewGeneratable]) {
        self.data = data
        self.views = views
    }

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        ChatCreateSectionView(model: self).anyView()
    }
}

// MARK: - ChatHistorySectionView

struct ChatCreateSectionView: View {

    let model: ChatCreateSection

    var body: some View {
            Section {
                ForEach(model.views, id: \.id) { value in
                    value.view()
                        .background(.white())
                        .frame(height: 76)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                }
            } header: {
                HStack {
                    Text(model.data.text)
                        .padding(16)
                        .font(.regular(13))
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width, height: model.data.size)
                .background(model.data.color)
            }
    }
}

// MARK: - ChatCreateSectionCases

enum ChatCreateSectionCases {

    // MARK: - Cases

    case contacts
    case invite
    case emptySection

    var text: String {
        switch self {
        case .contacts:
            return "Контакты"
        case .invite:
            return "Пригласить в AURA"
        case .emptySection:
            return ""
        }
    }

    var color: Color {
        switch self {
        case .contacts:
            return .aliceBlue
        case .invite, .emptySection:
            return .clear
        }
    }

    var size: CGFloat {
        switch self {
        case .contacts, .invite:
            return 36
        case .emptySection:
            return 0
        }
    }
}
