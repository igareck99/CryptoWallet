import SwiftUI

// MARK: - ChatHistoryView

struct ChatHistoryView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: ChatHistoryViewModel

    // MARK: - Private Properties

    private let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""
    private var searchResults: [String] {
        searchText.isEmpty ? names : names.filter { $0.contains(searchText) }
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
        }
    }

    // MARK: - Body Properties

    private var content: some View {
        List(searchResults, id: \.self) { name in
            NavigationLink(destination: Text(name)) {
                Text(name)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
    }
}
