import SwiftUI

// MARK: - SessionView

struct SessionView: View {

    // MARK: - Internal Properties

    var session: SessionItem

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                session.photo
                    .resizable()
                    .frame(width: 40, height: 40)
                    .scaledToFill()
                VStack(alignment: .leading) {
                    Text(session.device + ", Приложение Aura")
                        .font(.semibold(15))
                        .lineLimit(1)
                    Text(session.place + " • " + session.date)
                        .font(.regular(12))
                        .foregroundColor(.chineseBlack)
                        .lineLimit(1)
                        .offset(y: 2)
                    Spacer()
                }
            }
            Spacer()
            R.image.registration.arrow.image
        }
    }
}

// MARK: - SessionListView

struct SessionListView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: SessionViewModel
    @State private var selectedSession: SessionItem?
    @State private var isSelected = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Divider().padding(.top, 16)
            Text(R.string.localizable.sessionDescription())
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .font(.regular(13))
                .foregroundColor(.chineseBlack)
                .padding(.horizontal, 16)
            List {
                ForEach(viewModel.sessionsList) { session in
                    SessionView(session: session)
                        .listRowSeparator(.hidden)
                        .background(.white)
                        .onTapGesture {
                            viewModel.selectedSession = session
                            isSelected = true
                        }
                }
            }
            Divider()
                .padding(.top, 8)
            Button(action: {
                viewModel.sessionsList.removeAll()
                viewModel.send(.onDeleteAll)
            }, label: {
                Text(R.string.localizable.sessionFinishAll())
                    .font(.bold(15))
                    .foregroundColor(.white)
            }).frame(width: 225, height: 44, alignment: .center)
                .background(Color.dodgerBlue)
                .cornerRadius(8)
        }
        .popup(isPresented: $isSelected,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: .chineseBlack04) {
            SessionDetailView(viewModel: viewModel,
                              showModal: $isSelected)
                .frame(width: UIScreen.main.bounds.width, height: 375, alignment: .center)
                .cornerRadius(16)
        }
               .onAppear {
                   viewModel.send(.onAppear)
               }
               .listStyle(.inset)
               .navigationBarTitleDisplayMode(.inline)
               .toolbar {
                   ToolbarItem(placement: .principal) {
                       Text(R.string.localizable.sessionFinishOne())
                           .font(.bold(15))
                   }
               }
               .toolbar(.hidden, for: .tabBar)
    }
}
