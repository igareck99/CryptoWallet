import SwiftUI

// MARK: - SessionInfoView

struct SessionInfoView: View {

    // MARK: - Internal Properties

    var sessionInfoItem: SessionInfoItem

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text(sessionInfoItem.title)
                .font(.caption1Regular12)
                .foregroundColor(.romanSilver)
            Text(sessionInfoItem.info)
                .font(.bodySemibold17)
                .foregroundColor(.chineseBlack)
            Spacer()
        }
    }
}

// MARK: - SessionDetailView

struct SessionDetailView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: SessionViewModel
    @Binding var showModal: Bool

    // MARK: - Body

    var body: some View {
        let session_info: [SessionInfoItem] = [
            SessionInfoItem(title: R.string.localizable.sessionPlace(),
                            info: viewModel.selectedSession.place),
            SessionInfoItem(title: R.string.localizable.sessionTime(),
                            info: viewModel.selectedSession.date),
            SessionInfoItem(title: R.string.localizable.sessionApp(),
                            info: viewModel.selectedSession.device),
            SessionInfoItem(title: R.string.localizable.sessionIp(),
                            info: viewModel.selectedSession.ip)]
        GeometryReader { geometry in
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    showModal = false
                }, label: {
                    R.image.buyCellsMenu.close.image
                        .frame(width: 24, height: 24)
                        .padding(.leading, 24)
                })
                Spacer()
                Text(R.string.localizable.sessionAdditionalTitle())
                    .font(.callout2Semibold16)
                Spacer()
                Text("")
                    .frame(width: 40)
            }
            .offset(x: -10)
            .padding(.top, 18)
            Spacer()
            VStack(alignment: .leading) {
                ForEach(session_info) { session in SessionInfoView(sessionInfoItem: session)
                        .frame(height: 44)
                        .padding(.leading, 16)
                }
                Divider()
                    .padding(.top, 16)
                VStack(alignment: .center) {
                    Button(action: {
                        viewModel.send(.onDeleteOne(deviceId: viewModel.selectedSession.deviceId))
                        viewModel.sessionsList = viewModel.sessionsList.filter {
                            $0.deviceId != viewModel.selectedSession.deviceId }
                        self.showModal.toggle()
                    }, label: {
                        Text(R.string.localizable.sessionFinishOne())
                            .font(.bodySemibold17)
                            .foregroundColor(.white)
                    }).frame(width: 225, height: 44)
                        .background(Color.dodgerBlue)
                        .cornerRadius(8)
                        .padding(.leading, (geometry.size.width - 225) / 2)
                    Spacer()
                }
            }.padding(.top, 31)
        }.background(.white)
        }
    }
}
