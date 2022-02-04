import SwiftUI

// MARK: - ReserveCopyView

struct ReserveCopyView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ReserveCopyViewModel

    // MARK: - Body

    var body: some View {
        Divider().padding(.top, 16)
        List {
            ReserveCopyInfoCellView()
                .listRowSeparator(.hidden)
                .padding(.top, 20)
            VStack(alignment: .leading, spacing: 16) {
                ReserveCellView(text: R.string.localizable.reserveCopyCreateCopy())
                    .background(.white())
                    .onTapGesture {
                        print("Открывается окно с google")
                    }
                Divider()
                Text(R.string.localizable.reserveCopyAutomaticCopy().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                SecurityCellView(title: R.string.localizable.reserveCopyDiskCopy(),
                                 currentState: "Никогда")
                    .listRowSeparator(.hidden)
            }.listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.chatSettingsReserveCopy())
                    .font(.bold(15))
            }
        }
    }
}
// MARK: - ReserveCopyInfoCellView

struct ReserveCopyInfoCellView: View {

    // MARK: - Internal Properties

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(R.string.localizable.chatSettingsReserveCopy().uppercased())
                .font(.bold(12))
                .foreground(.darkGray())
            Text(R.string.localizable.reserveCopyCreated())
                .padding(.top, 4)
            Text("Google Диск: \n28 октября 2020, 13:23")
                .font(.regular(12))
                .lineLimit(2)
                .foreground(.darkGray())
        }
    }
}
