import SwiftUI

// MARK: - ReserveCopyView

struct ReserveCopyView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ReserveCopyViewModel
    @State private var showChangeReserveTime = false
    @State private var creatingCopy = false

    // MARK: - Body

    var body: some View {
        Divider().padding(.top, 16)
        List {
            ReserveCopyInfoCellView()
                .listRowSeparator(.hidden)
                .padding(.top, 20)
            VStack(alignment: .leading, spacing: 20) {
                switch creatingCopy {
                case true:
                    VStack(spacing: 11) {
                        ReserveCellView(text: R.string.localizable.reserveCopyCreateCopy(),
                                        tapped: creatingCopy)
                            .background(.white())
                        ProgressBarView(value: $viewModel.progressValue,
                                        percent: $viewModel.percent,
                                        size_of_data: $viewModel.size_of_data,
                                        creatingCopy: $creatingCopy)
                            .frame(height: 29)
                            .onAppear {
                                while viewModel.size_of_data - viewModel.progressValue > 0 {
                                    viewModel.send(.onUpload)
                                }
                            }
                    }
                case false:
                    ReserveCellView(text: R.string.localizable.reserveCopyCreateCopy(),
                                    tapped: creatingCopy)
                        .background(.white())
                        .onTapGesture {
                            creatingCopy = true
                        }
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
                Text("example@gmail.com")
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

// MARK: - ProgressBarView

struct ProgressBarView: View {

    // MARK: - Internal Properties

    @Binding var value: Float
    @Binding var percent: Float
    @Binding var size_of_data: Float
    @Binding var creatingCopy: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 24) {
                    ZStack(alignment: .leading) {
                        Rectangle().frame(width: geometry.size.width - 40,
                                          height: 5)
                            .opacity(0.3)
                            .foregroundColor(Color(.lightBlue()))
                        Rectangle().frame(width: min(CGFloat(self.value)
                                                     * geometry.size.width - 40,
                                                     geometry.size.width - 40),
                                          height: 5)
                            .foregroundColor(Color(.blue()))
                    }.cornerRadius(45.0)
                    R.image.reserveCopy.grayCancel.image
                        .onTapGesture {
                            creatingCopy = false
                        }
                }
                Text("Загрузка: \(String(format: "%0.1f", value)) МБ из " +
                    "\(String(format: "%0.1f", size_of_data)) " +
                    "МБ (\(String(format: "%0.0f", percent * 100))%)")
                    .lineLimit(1)
                    .font(.bold(12))
                    .foreground(.darkGray())
            }
    }
}
}
