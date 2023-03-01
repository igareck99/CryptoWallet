import SwiftUI

// MARK: - SuccessFacilityView

struct SuccessFacilityView: View {

    // MARK: - Internal Properties

    @Binding var showSuccessFacility: Bool
    @State var transaction: FacilityApproveModel
    let sources: SuccessFacilityResourcable.Type = SuccessFacilityResources.self

    // MARK: - Body

    var body: some View {
        content
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .center) {
            headerView
                .padding(.horizontal, 16)
                .padding(.top, 18)
            Divider()
                .padding(.top, 16)
            checkImageView
                .padding(.top, 40)
            coinDataView
                .padding(.top, 16)
            rectangleView
                .padding(.top, 24)
                .padding(.horizontal, 16)
            Spacer()
            sendButton
                .padding(.bottom, 42)
        }
    }

    private var headerView: some View {
        HStack {
            sources.close
                .onTapGesture {
                    showSuccessFacility = false
                }
            Spacer()
            Text(sources.successFacilityViewTitle)
                .font(.bold(15))
            Spacer()
        }
    }

    private var checkImageView: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foreground(.lightBlue(0.4))
            sources.greenCheck
        }
    }

    private var coinDataView: some View {
		VStack(spacing: 12) {
			Text(transaction.transferAmount + " " + transaction.transferCurrency)
				.font(.regular(32))

			Text(transaction.comissionAmount + " " + transaction.comissionCurrency)
				.font(.regular(15))
				.foreground(.darkGray())
		}
	}

    private var rectangleView: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(Color(.blue(0.1)))
                .frame(height: 224)
            VStack {
                sources.address
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                VStack(spacing: 6) {
                    Text(transaction.reciverName ?? "")
                        .font(.semibold(15))
                    Text(transaction.reciverAddress ?? "")
                        .foreground(.darkGray())
                        .font(.regular(12))
                }
                Button {
                } label: {
                    Text(sources.successFacilityViewAddFavorites)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.semibold(15))
                        .padding()
                        .foreground(.blue())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.blue()), lineWidth: 1)
                        )
                }
                .cornerRadius(8)
                .padding(.horizontal, 84)
                .padding(.top, 24)
            }
            .padding(.top, 24)
        }
    }

    private var sendButton: some View {
        VStack(alignment: .center,
               spacing: 8) {
            Divider()
            Button {
            } label: {
                Text(sources.successFacilityViewOKClose)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.semibold(15))
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
            Button {
            } label: {
                Text(sources.successFacilityViewShowTransaction)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.semibold(15))
                    .padding()
                    .foreground(.blue())
            }
        }
    }
}
