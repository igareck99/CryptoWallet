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
                Text(R.string.localizable.facilityApproveValidateTransaction())
                    .font(.system(size: 17, weight: .semibold))
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
			Text(R.string.localizable.walletSend())
				.font(.system(size: 17, weight: .semibold))
				.padding()
				.foregroundColor(.white)
		}
		.frame(width: 237, height: 48)
		.background(Color.azureRadianceApprox)
		.cornerRadius(10)
	}

    private var receiverCellView: some View {
        HStack(spacing: 0) {
            R.image.transaction.userPlaceholder.image
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.transaction.reciverName ?? "По адресу")
                    .font(.system(size: 17))
                    .foregroundColor(.woodSmokeApprox)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .padding(.trailing, 16)
                    .padding(.leading, 8)
            }
        }
    }
}
