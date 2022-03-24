import SwiftUI

// MARK: - FacilityApproveView

struct FacilityApproveView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: FacilityApproveViewModel
    @State var showSuccessFacility = false

    // MARK: - Body

    var body: some View {
        content
        .onAppear {
            viewModel.send(.onAppear)
        }
        .onChange(of: showSuccessFacility, perform: { newValue in
            if !newValue {
                showNavBar()
            }
        })
        .popup(
            isPresented: $showSuccessFacility,
            type: .toast,
            position: .bottom,
            closeOnTap: false,
            closeOnTapOutside: false,
            backgroundColor: Color(.black(0.4)),
            view: {
                SuccessFacilityView(showSuccessFacility: $showSuccessFacility,
                                    transaction: viewModel.transaction)
                    .frame(height: UIScreen.main.bounds.height - 44)
                    .background(
                        CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                            .fill(Color(.white()))
                    )
            }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.facilityApproveTitle())
                    .font(.bold(15))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {

                } label: {
                    R.image.transaction.filter.image
                        .onTapGesture {
                        }
                }
            }
        }

    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.top, 16)
            Text(R.string.localizable.facilityApproveCheck())
                .font(.semibold(15))
                .foreground(.lightOrange())
                .multilineTextAlignment(.leading)
                .padding(.leading, 16)
                .padding(.top, 24)
            Text(R.string.localizable.facilityApproveReceiver().uppercased())
                .font(.bold(12))
                .foreground(.darkGray())
                .padding(.leading, 16)
                .padding(.top, 24)
            receiverCellView
                .padding(.leading, 16)
            List {
                ForEach(viewModel.cellType) { item in
                    FacilityApproveCellView(item: item)
                        .frame(height: 72)
                }
            }
            .listStyle(.plain)
            Spacer()
            sendButton
        }
    }

    private var sendButton: some View {
        VStack(spacing: 8) {
            Divider()
            Button {
                showSuccessFacility = true
                hideNavBar()
            } label: {
                Text(R.string.localizable.walletSend().uppercased())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.semibold(14))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .background(Color(.blue()))
            .cornerRadius(4)
            .padding(.horizontal, 81)
        }
    }

    private var receiverCellView: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 16) {
                    viewModel.transaction.userImage
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.nameTitle)
                            .font(.regular(12))
                            .foreground(.darkGray())
                        Text(viewModel.transaction.nameSurname)
                            .font(.bold(15))
                    }
                }
            }
        }
    }
}

// MARK: - FacilityApproveCellView

struct FacilityApproveCellView: View {

    // MARK: - Internal Properties

    var item: ApproveFacilityCellTitle

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color(.blue(0.1)))
                            .frame(width: 40, height: 40)
                        item.image
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.regular(12))
                            .foreground(.darkGray())
                        Text(item.text)
                            .font(.bold(15))
                    }
                }
            }
        }
    }
}
