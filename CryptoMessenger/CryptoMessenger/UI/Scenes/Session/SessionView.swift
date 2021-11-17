import SwiftUI

struct SessionView: View {
    var session: SessionItem
    var body: some View {
        HStack {
            Image(uiImage: session.photo)
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: 16)
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
            .offset(x: 16)
            .padding(.top, 11)
            Image(uiImage: R.image.registration.arrow()!)
                .resizable()
                .frame(width: 7, height: 12)
                .padding(.trailing, -16)
                .padding(.top, 26)
            Spacer()
        }
    }
}

struct ContentView: View {
    let sessions = SessionItem.sessions()
    var body: some View {
        NavigationView {
            List {
                ForEach(sessions) { session in
                    SessionView(session: session)
                }
            }
            .background(.red())
            .listSeparatorStyle(style: .none)
            .padding(.leading, -20)
            .padding(.trailing, -20)
            .navigationBarTitle(Text("Управление сессиями"))
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().background(.red())
    }
}

var sessionList: [SessionItem] = [
    .init(id: 1, photo: R.image.session.iphone(), device: "iPhone", place: "Москва, Россия", date: "сегодня в 14:11"),
    .init(id: 1, photo: R.image.session.iphone(), device: "iPhone", place: "Стамбул, Турция", date: "вчера в 10:09")
]
