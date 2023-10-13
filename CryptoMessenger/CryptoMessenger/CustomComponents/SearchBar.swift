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
            Rectangle().foregroundColor(Color(.init(242, 247, 252)))
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
					.foregroundColor(Color(.init(133, 135, 141)))
					.padding(.leading, 4)
                TextField("", text: $searchText) { startedEditing in
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
                .font(.bodyRegular17)
				.foregroundColor(.chineseBlack)
				.padding(.leading, 6)
                .placeholder(when: !searching && searchText.isEmpty) {
					Text(placeholder)
						.foregroundColor(Color(.init(133, 135, 141)))
						.padding(.leading, 4)
				}
            }
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
