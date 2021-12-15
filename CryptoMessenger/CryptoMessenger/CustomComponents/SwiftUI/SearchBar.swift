import SwiftUI

// MARK: - SearchBar

struct SearchBar: View {

    // MARK: - Internal Properties

    let placeholder: String
    @Binding var searchText: String
    @Binding var searching: Bool

    // MARK: - Body

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(.paleBlue()))
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                TextField(placeholder, text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 36)
        .cornerRadius(8)
    }
}

// MARK: - UIApplication ()

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
