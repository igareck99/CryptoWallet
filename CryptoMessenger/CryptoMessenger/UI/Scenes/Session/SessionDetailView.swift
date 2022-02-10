import SwiftUI

// MARK: - SessionInfoView

struct SessionInfoView: View {

    // MARK: - Internal Properties

    var sessionInfoItem: SessionInfoItem

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Text(sessionInfoItem.title)
                .font(.regular(12))
                .foreground(.darkGray())
            Text(sessionInfoItem.info)
                .font(.bold(15))
                .foreground(.darkBlack())
            Spacer()
        }
    }
}

// MARK: - SessionDetailView

struct SessionDetailView: View {

    // MARK: - Internal Properties

    var session: SessionItem
    @ObservedObject var viewModel: SessionViewModel
    @Binding var showModal: Bool

    // MARK: - Body

    var body: some View {
        let session_info: [SessionInfoItem] = [
            SessionInfoItem(title: R.string.localizable.sessionPlace(), info: session.place),
            SessionInfoItem(title: R.string.localizable.sessionTime(), info: session.date),
            SessionInfoItem(title: R.string.localizable.sessionApp(), info: session.device),
            SessionInfoItem(title: R.string.localizable.sessionIp(), info:
                                session.ip)]
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
                    .font(.bold(16))
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
                        viewModel.sessionsList = viewModel.sessionsList.filter { $0.device_id != session.device_id }
                        self.showModal.toggle()
                    }, label: {
                        Text(R.string.localizable.sessionFinishOne())
                            .font(.bold(15))
                            .foreground(.white())
                    }).frame(width: 225, height: 44)
                        .background(.blue())
                        .cornerRadius(8)
                        .padding(.leading, (geometry.size.width - 225) / 2)
                    Spacer()
                }
            }.padding(.top, 31)
        }.background(.white())
        }
    }
}
