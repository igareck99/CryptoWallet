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

    @State var selectedSession: SessionItem?

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .center, spacing: 16) {
                    List {
                        Text(R.string.localizable.sessionDescription())
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .font(.regular(13))
                            .foreground(.darkGray())
                            .padding([.leading, .trailing], 16)

                        ForEach(SessionItem.sessions()) { session in
                            SessionView(session: session)
                                .onTapGesture {
                                    selectedSession = session
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.sesisonTitle())
                }
            }
            .sheet(item: $selectedSession) { session in
                SessionView(session: session)
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
