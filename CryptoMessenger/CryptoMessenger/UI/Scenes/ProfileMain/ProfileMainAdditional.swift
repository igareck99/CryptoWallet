import SwiftUI

// MARK: - ProfileMainAdditional

struct ProfileMainAdditional: View {

    // MARK: - Internal Properties

    var balance: String
    var cells: [ProfileMainMenuItem]

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(uiImage: R.image.buyCellsMenu.aura() ?? UIImage())
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(balance)
                    .font(.regular(16))
            }.padding()
            Divider()
            List {
                ForEach(0..<cells.count - 2, id: \.self) { item in
                    ProfileMainAdditionalCell(item: cells[item])
                }
                Divider()
                ForEach(cells.count - 2..<cells.count, id: \.self) { item in
                    ProfileMainAdditionalCell(item: cells[item])
                }
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
        }
    }
}

// MARK: - ProfileMainAdditionalCell

struct ProfileMainAdditionalCell: View {

    // MARK: - Internal Properties

    var item: ProfileMainMenuItem

    // MARK: - Body

    var body: some View {
        HStack {
            HStack(spacing: 16) {
                ZStack {
                    Rectangle()
                        .foreground(.lightBlue())
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    Image(uiImage: item.image ?? UIImage())
                        .background(.lightBlue())
                        .frame(width: 20, height: 20)
                }
                Text(item.text)
                    .font(.regular(15))
            }
            Spacer()
            HStack {
                if item.notifications > 0 {
                    ZStack {
                        Image(uiImage: UIImage())
                            .frame(width: 20, height: 20)
                            .background(.lightRed())
                            .clipShape(Circle())
                        Text(String(item.notifications))
                            .font(.regular(15))
                            .foreground(.white())
                    }
                }
                Image(uiImage: R.image.additionalMenu.grayArrow() ?? UIImage())
            }
        }.frame(height: 64)
    }
}

// MARK: - ProfileMainView_Preview

struct ProfileMainViewPreviewView: PreviewProvider {
    static var previews: some View {
        ProfileMainAdditional(balance: "0.50 AUR", cells: ProfileMainMenuItem.getmenuItems())
    }
}
