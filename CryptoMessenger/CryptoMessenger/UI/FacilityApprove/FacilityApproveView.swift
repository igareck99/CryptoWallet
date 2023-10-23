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
                // Оставил для информации по логике отображения нав бара
//                showNavBar()
            }
        })
        .popup(
            isPresented: viewModel.isSnackbarPresented,
            alignment: .bottom
        ) {
            Snackbar(
                text: viewModel.messageText,
                color: .spanishCrimson
            )
        }
        .popup(
            isPresented: $showSuccessFacility,
            type: .toast,
            position: .bottom,
            closeOnTap: false,
            closeOnTapOutside: false,
            backgroundColor: Color.chineseBlack04,
            view: {
                SuccessFacilityView(
					showSuccessFacility: $showSuccessFacility,
					transaction: viewModel.transaction
				)
                    .frame(height: UIScreen.main.bounds.height - 44)
                    .background(
                        CornerRadiusShape(radius: 16, corners: [.topLeft, .topRight])
                            .fill(viewModel.resources.background)
                    )
            }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.resources.facilityApproveValidateTransaction)
                    .font(.bodySemibold17)
            }
        }
    }

    // MARK: - Private Properties

    private var content: some View {
		ScrollView {
			VStack(alignment: .leading) {
                Text(viewModel.resources.facilityApproveReceiver.uppercased())
					.font(.caption1Regular12)
                    .foregroundColor(viewModel.resources.textColor)
					.lineLimit(1)
					.truncationMode(.middle)
					.padding(.top, 24)

				receiverCellView

				ForEach(viewModel.cellType) { item in
					FacilityApproveCellView(item: item)
						.frame(height: 64)
				}

                Text(viewModel.resources.facilityApproveCheck)
					.font(.calloutRegular16)
                    .foregroundColor(viewModel.resources.checkTextColor)
					.multilineTextAlignment(.leading)
			}
			.padding(.leading, 16)
		}
		.safeAreaInset(edge: .bottom) {
			sendButton
				.frame(width: 237, height: 48)
				.padding(.bottom)
		}
    }

	private var sendButton: some View {
		Button {
			viewModel.send(.onTransaction)
		} label: {
            Text(viewModel.resources.walletSend)
				.font(.bodySemibold17)
				.padding()
                .foregroundColor(viewModel.resources.background)
		}
		.frame(width: 237, height: 48)
        .background(viewModel.resources.buttonBackground)
		.cornerRadius(10)
	}

    private var receiverCellView: some View {
        HStack(spacing: 0) {
            viewModel.resources.userPlaceholder
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.transaction.reciverName ?? viewModel.resources.facilityApproveToAddress)
                    .font(.bodyRegular17)
                    .foregroundColor(viewModel.resources.titleColor)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.trailing, 16)
                    .padding(.leading, 8)
            }
        }
    }
}
