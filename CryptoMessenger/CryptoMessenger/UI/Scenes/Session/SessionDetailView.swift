import SwiftUI

struct SessionInfoView: View {
    var sessionInfoItem: SessionInfoItem
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

struct SessionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var session: SessionItem
    var body: some View {
        let session_info: [SessionInfoItem] = [
            SessionInfoItem(title: R.string.localizable.sessionTime(), info: session.date),
            SessionInfoItem(title: R.string.localizable.sessionPlace(), info: session.place),
            SessionInfoItem(title: R.string.localizable.sessionApp(), info: session.device),
            SessionInfoItem(title: R.string.localizable.sessionIp(), info: session.IP)]
        VStack {
            Spacer()
            VStack {
                HStack(spacing: 73) {
                    Button(action: {
                        print("CloseScreen")
                    }, label: {
                        Image(uiImage: R.image.buyCellsMenu.close() ?? UIImage())
                            .frame(width: 24, height: 24)
                            .padding(.leading, 16)
                    })
                    Text(R.string.localizable.sessionAdditionalTitle())
                        .font(.bold(16))
                        .frame(width: 149, height: 20, alignment: .center)
                }.padding(.bottom, 30)
                    .padding(.leading, -UIScreen.main.bounds.width / 2 + 32)
                List {
                    ForEach(session_info) {
                        session in SessionInfoView(sessionInfoItem: session)
                    }
                }
                .listSeparatorStyle(style: .none)
                .listStyle(.inset)
                .padding(.leading, -20)
                .padding(.trailing, -20)
            }
            Divider()
            Button(action: {
                close()
                print("CloseSessionButton")
            }, label: {
                Text(R.string.localizable.sessionFinishOne())
                    .font(.bold(15))
                    .foreground(.white())
            }).frame(width: 225, height: 44, alignment: .center)
                .background(.blue())
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 375)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.bottom, -UIScreen.main.bounds.height / 2)
    }
    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: SessionItem.sessionsInfo(id: 1))
    }
}
