import SwiftUI

// MARK: - ReationsGridView

struct ReationsGridView: View {

    // MARK: - Internal Properties

    let columns: [GridItem]
    let items: [any ViewGeneratable]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items, id:\ .id) { value in
                value.view()
            }
        }
    }
}
