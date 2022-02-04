import SwiftUI

// MARK: - ReserveCopyView

struct ReserveCopyView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ReserveCopyViewModel
    @State private var showChangeReserveTime = false

    // MARK: - Body

    var body: some View {
        Divider().padding(.top, 16)
        List {
            ReserveCopyInfoCellView()
                .listRowSeparator(.hidden)
                .padding(.top, 20)
            VStack(alignment: .leading, spacing: 20) {
                ReserveCellView(text: R.string.localizable.reserveCopyCreateCopy())
                    .background(.white())
                    .onTapGesture {
                        print("Создается копия")
                    }
                Divider()
                Text(R.string.localizable.reserveCopyAutomaticCopy().uppercased())
                    .font(.bold(12))
                    .foreground(.darkGray())
                    .padding(.top, 4)
                SecurityCellView(title: R.string.localizable.reserveCopyDiskCopy(),
                                 currentState: viewModel.reserveCopyTime)
                    .background(.white())
                    .padding(.top, 8)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        showChangeReserveTime = true
                    }
            }.listRowSeparator(.hidden)
                .padding(.top, 16)
            VStack(alignment: .leading, spacing: 4) {
                Text(R.string.localizable.reserveCopyAccountCopy())
                    .font(.regular(16))
                Text("ddskckmck")
                    .foreground(.darkGray())
                    .font(.bold(12))
            }
                .listRowSeparator(.hidden)
                .padding(.top, 16)
            ReserveCellView(text: R.string.localizable.reserveCopyChangeAccount())
                .background(.white())
                .padding(.top, 16)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    print("Открывается окно с google")
                }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .confirmationDialog("", isPresented: $showChangeReserveTime, titleVisibility: .hidden) {
            ForEach([R.string.localizable.reserveCopyEveryMonth(),
                     R.string.localizable.reserveCopyEveryDay(),
                     R.string.localizable.reserveCopyNever()], id: \.self) { item in
                Button(item) {
                    viewModel.updateReserveCopyTime(item: item)
                }
            }
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
