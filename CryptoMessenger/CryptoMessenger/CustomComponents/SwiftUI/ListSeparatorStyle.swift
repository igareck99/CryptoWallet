import SwiftUI

// MARK: - ListSeparatorStyle

struct ListSeparatorStyle: ViewModifier {

    // MARK: - Internal Properties

    let style: UITableViewCell.SeparatorStyle

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .onAppear {
                UITableView.appearance().separatorStyle = style
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
    }
}

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func listSeparatorStyle(style: UITableViewCell.SeparatorStyle) -> some View {
        ModifiedContent(content: self, modifier: ListSeparatorStyle(style: style))
    }
}
