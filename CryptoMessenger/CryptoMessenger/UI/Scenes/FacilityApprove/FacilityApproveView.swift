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
                SuccessFacilityView(
					showSuccessFacility: $showSuccessFacility,
					transaction: viewModel.transaction
				)
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
        }
    }

    // MARK: - Private Properties

    private var content: some View {
		ScrollView {
			VStack(alignment: .leading) {

				Text(R.string.localizable.facilityApproveReceiver().uppercased())
					.font(.system(size: 12))
					.foregroundColor(.regentGrayApprox)
					.lineLimit(1)
					.truncationMode(.middle)
					.padding(.top, 24)

				receiverCellView

				ForEach(viewModel.cellType) { item in
					FacilityApproveCellView(item: item)
						.frame(height: 64)
				}

				Text(R.string.localizable.facilityApproveCheck())
					.font(.system(size: 16))
					.foregroundColor(.jaffaApprox)
					.multilineTextAlignment(.leading)
				sendButton
			}
			.padding(.leading, 16)
		}
    }

    private var sendButton: some View {
        VStack(spacing: 8) {
            Button {
//                showSuccessFacility = true
//                hideNavBar()
				viewModel.send(.onTransaction)
            } label: {
                Text(R.string.localizable.walletSend())
                    .frame(minWidth: 0, maxWidth: .infinity)
					.font(.system(size: 17, weight: .semibold))
                    .padding()
                    .foregroundColor(.white)
            }
			.background(Color.azureRadianceApprox)
			.cornerRadius(10)
            .padding(.horizontal, 81)
        }
    }

	private var receiverCellView: some View {
		VStack(spacing: 16) {
			HStack(spacing: 16) {
				R.image.transaction.userPlaceholder.image
					.resizable()
					.clipShape(Circle())
					.frame(width: 40, height: 40)
				VStack(alignment: .leading, spacing: 2) {
					Text(viewModel.transaction.reciverName ?? "По адресу")
					.font(.system(size: 17))
					.foregroundColor(.woodSmokeApprox)
					.lineLimit(1)
					.truncationMode(.middle)
					.padding(.trailing, 16)
				}
			}
		}
	}
}
