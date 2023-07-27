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
                .font(.system(size: 15, weight: .bold))
            Spacer()
        }
    }

    private var checkImageView: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(sources.avatarBackground)
            sources.greenCheck
        }
    }

    private var coinDataView: some View {
		VStack(spacing: 12) {
			Text(transaction.transferAmount + " " + transaction.transferCurrency)
                .font(.system(size: 32, weight: .regular))

			Text(transaction.comissionAmount + " " + transaction.comissionCurrency)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(sources.textColor)
		}
	}

    private var rectangleView: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(sources.avatarBackground)
                .frame(height: 224)
            VStack {
                sources.address
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                VStack(spacing: 6) {
                    Text(transaction.reciverName ?? "")
                        .font(.system(size: 15, weight: .semibold))
                    Text(transaction.reciverAddress ?? "")
                        .foregroundColor(sources.textColor)
                        .font(.system(size: 12, weight: .regular))
                }
                Button {
                } label: {
                    Text(sources.successFacilityViewAddFavorites)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 15, weight: .semibold))
                        .padding()
                        .foregroundColor(sources.buttonBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(sources.buttonBackground, lineWidth: 1)
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
                    .font(.system(size: 15, weight: .semibold))
                    .padding()
                    .foregroundColor(sources.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(sources.background, lineWidth: 2)
                    )
            }
            .background(sources.buttonBackground)
            .cornerRadius(4)
            .padding(.horizontal, 81)
            Button {
            } label: {
                Text(sources.successFacilityViewShowTransaction)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 15, weight: .semibold))
                    .padding()
                    .foregroundColor(sources.buttonBackground)
            }
        }
    }
}
