import SwiftUI

// MARK: - SelectContactCheapsView

struct SelectContactChipsView: View {

    // MARK: - Internal Properties

    let data: SelectContactChips
    @State var textFieldPadding: CGFloat = 0
    @State private var moveView = false
    @State var textFieldTopPadding: CGFloat = 0

    // MARK: - Body

    var body: some View {
        Group {
            if !data.views.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    chips
                        .frame(height: CGFloat(getRows().count) * 40)
                    TextField(data.text.isEmpty ? R.string.localizable.createChannelAdding() : "",
                              text: data.$text)
                    .font(.regular(17))
                    .frame(height: 40)
                }
            } else {
                ZStack(alignment: .centerLastTextBaseline) {
                    TextField(data.text.isEmpty ? R.string.localizable.createChannelAdding() : "",
                              text: data.$text)
                    .font(.regular(17))
                    .frame(height: 40)
                }
            }
        }
    }

    private var chips: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            VStack(alignment: .leading, content: {
                ForEach(getRows().indices, id: \.self) { rows in
                    HStack(spacing: 4) {
                        ForEach(getRows()[rows], id: \.id) { row in
                            row.view()
                        }
                    }
                }
            })
            .frame(width: UIScreen.main.bounds.width - 32, alignment: .leading)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
        })
    }
    
    private func getRows() -> [[any ViewGeneratable]] {
        var rows: [[any ViewGeneratable]] = []
        var currentRow: [any ViewGeneratable] = []
        var totalWidth: CGFloat = 0
        var screenWidth = UIScreen.main.bounds.width - 32
        data.views.forEach { tag in
            totalWidth += (tag.getItemWidth() + 4)
            if totalWidth > screenWidth {
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.getItemWidth() + 4) : 0)
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
            } else {
                currentRow.append(tag)
            }
        }
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        } else {
            DispatchQueue.main.async {
                textFieldPadding = 0
                textFieldTopPadding = 0
            }
        }
        return rows
    }
}
