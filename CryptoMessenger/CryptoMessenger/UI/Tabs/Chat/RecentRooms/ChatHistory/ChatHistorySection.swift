import SwiftUI

// MARK: - ChatHistorySection

struct ChatHistorySection: Identifiable, ViewGeneratable {

    var id = UUID()
    let data: ChatHistirySectionCases
    let views: [any ViewGeneratable]

    // MARK: - Lifecycle

    init(data: ChatHistirySectionCases,
         views: [any ViewGeneratable]) {
        self.data = data
        self.views = views
    }

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        ChatHistorySectionView(model: self).anyView()
    }
}

// MARK: - ChatHistorySectionView

struct ChatHistorySectionView: View {

    let model: ChatHistorySection

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
                switch model.data {
                case .emptySection:
                    EmptyView()
                default:
                    HStack {
                        Text(model.data.text)
                            .padding(16)
                            .font(.footnoteRegular13)
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 36)
                    .background(.paleBlue())
                }
            }
    }
}

// MARK: - ChatHistirySectionCases

enum ChatHistirySectionCases {

    // MARK: - Cases

    case joinedChats
    case gloabalChats
    case emptySection

    var text: String {
        switch self {
        case .joinedChats:
            return "Чаты"
        case .gloabalChats:
            return "Глобальный поиск"
        case .emptySection:
            return ""
        }
    }
}
