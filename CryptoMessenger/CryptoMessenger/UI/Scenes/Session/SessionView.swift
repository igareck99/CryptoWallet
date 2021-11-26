import SwiftUI

// MARK: - SessionListView

struct SessionView: View {

    // MARK: - Internal Properties

    var session: SessionItem

    // MARK: - Body

    var body: some View {
        HStack {
            Image(uiImage: session.photo)
                .resizable()
                .frame(width: 40, height: 40)
                .offset(x: -4)
                .padding(.leading, 16)
                .padding(.top, 0)
            VStack(alignment: .leading) {
                Text(session.device + R.string.localizable.sessionAppText())
                    .font(.semibold(15))
                    .lineLimit(1)
                Text(session.place + R.string.localizable.sessionSeparator() + session.date)
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

// MARK: - ContentView

struct SessionListView: View {

    // MARK: - Internal Properties

    @State var selectedSession: SessionItem?
    @State var isSelected = false
    @ObservedObject var viewModel = SessionViewModel()

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 16) {
                List {
                    Text(R.string.localizable.sessionDescription())
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .font(.regular(13))
                        .foreground(.darkGray())
                        .padding([.leading, .trailing], 16)
                    ForEach(viewModel.listData) { session in
                        SessionView(session: session)
                            .padding([.leading, .trailing], 16)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init())
                            .onTapGesture {
                                selectedSession = session
                                isSelected = true
                            }
                    }
                }
                .listRowSeparator(.hidden)
                .listStyle(.plain)
                Divider()
                Button(action: {
                    viewModel.listData.removeAll()
                }, label: {
                    Text(R.string.localizable.sessionFinishAll())
                        .font(.bold(15))
                        .foreground(.white())
                }).frame(width: 225, height: 44, alignment: .center)
                    .background(.blue())
                    .cornerRadius(8)
            }
            .popup(isPresented: $isSelected,
                   type: .toast,
                   position: .bottom,
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   backgroundColor: Color(.black(0.3))) {
                SessionDetailView(session: selectedSession ?? SessionItem.sessionsInfo(id: 2),
                                  viewModel: viewModel,
                                  showModal: isSelected)
                    .frame(width: UIScreen.main.bounds.width, height: 375, alignment: .center)
                    .cornerRadius(16)
            }
                   .listSeparatorStyle(style: .none)
                   .listStyle(.inset)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.sesisonTitle())
            }
        }
    }
}

// MARK: - SessionListView_Previews

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionListView()
    }
}
