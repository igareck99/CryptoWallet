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

    @Environment(\.presentationMode) private var presentationMode
    var session: SessionItem
    @ObservedObject var viewModel: SessionViewModel
    @State var showModal: Bool

    // MARK: - Body

    var body: some View {
        let session_info: [SessionInfoItem] = [
            SessionInfoItem(title: R.string.localizable.sessionTime(), info: session.date),
            SessionInfoItem(title: R.string.localizable.sessionPlace(), info: session.place),
            SessionInfoItem(title: R.string.localizable.sessionApp(), info: session.device),
            SessionInfoItem(title: R.string.localizable.sessionIp(), info:
                                session.ip)]
        GeometryReader { screen in
        VStack {
            HStack(spacing: 73) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(uiImage: R.image.buyCellsMenu.close() ?? UIImage())
                        .frame(width: 24, height: 24)
                        .padding(.leading, 24)
                })
                Text(R.string.localizable.sessionAdditionalTitle())
                    .font(.bold(16))
                    .frame(width: 149, height: 20, alignment: .center)
            }.padding(.leading, -screen.size.width / 2 + 32)
            Spacer()
            VStack {
                List {
                    ForEach(session_info) { session in SessionInfoView(sessionInfoItem: session)
                            .padding([.leading, .trailing], 16)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init())
                    }
                }
                Divider()
                HStack {
                    Button(action: {
                        let index = viewModel.listData.firstIndex { $0.date == session.date }
                        viewModel.listData.remove(at: index ?? 0)
                        self.showModal.toggle()
                    }, label: {
                        Text(R.string.localizable.sessionFinishOne())
                            .font(.bold(15))
                            .foreground(.white())
                    }).frame(width: 225, height: 44)
                        .background(.blue())
                        .cornerRadius(8)
                }.padding(.leading, (screen.size.width - 225) / 2 - 100)
                Spacer()
            }
        }.background(.white())
    }
    }
}
