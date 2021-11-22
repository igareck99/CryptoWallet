import SwiftUI

struct SessionView: View {
    var session: SessionItem
    var body: some View {
        HStack {
            Image(uiImage: session.photo)
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: -4)
                .padding(.leading, 16)
                .padding(.top, 0)
            VStack(alignment: .leading) {
                Text(session.device + ", Приложение Aura")
                    .font(.semibold(15))
                    .lineLimit(1)
                Text(session.place + " • " + session.date)
                    .font(.regular(12))
                    .foreground(.darkGray())
                    .lineLimit(1)
                Spacer()
            }
            .offset(x: 1)
            .padding(.top, 11)
            Image(uiImage: R.image.registration.arrow()!)
                .resizable()
                .frame(width: 7, height: 12)
                .padding(.trailing, -16)
                .padding(.top, 26)
        }
    }
}
struct ContentView: View {
    let sessions = sessions_list
    @State var presentSheet = false
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center, spacing: 16) {
                    Text(R.string.localizable.sessionDescription())
                        .font(.regular(13))
                        .foreground(.darkGray())
                        .padding(.leading, -16)
                        .lineLimit(3)
                        .navigationBarTitle(R.string.localizable.sesisonTitle(), displayMode: .inline)
                    List {
                        ForEach(sessions) { session in
                            NavigationLink(destination: SessionDetailView(session: session)) {
                                SessionView(session: session)
                            }
                        }
                    }
                    .listSeparatorStyle(style: .none)
                    .listStyle(.inset)
                    .padding(.leading, -20)
                    .padding(.trailing, -20)
                }
                Divider()
                CloseAllSessionsButton()
            }
        }
    }
}

struct CloseAllSessionsButton: View {
    let text = R.string.localizable.sessionFinishAll()
    var body: some View {
        Button(action: {
            print("CloseAllSessionsButton")
        }, label: {
            Text(R.string.localizable.sessionFinishAll())
                .font(.bold(15))
                .foreground(.white())
        }).frame(width: 225, height: 44, alignment: .center)
            .background(.blue())
            .cornerRadius(8)
    }
}

struct ScreenView: View {
    var body: some View {
        ContentView()
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}

var sessions_list = SessionItem.sessions()
