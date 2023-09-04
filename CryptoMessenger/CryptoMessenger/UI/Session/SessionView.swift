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
                    Text(session.device + R.string.localizable.sessingAura())
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                    Text(session.place + " • " + session.date)
                        .font(.system(size: 12, weight: .regular))
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
            Text(viewModel.resources.sessionDescription)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(viewModel.resources.title)
                .padding(.horizontal, 16)
            List {
                ForEach(viewModel.sessionsList) { session in
                    SessionView(session: session)
                        .listRowSeparator(.hidden)
                        .background(viewModel.resources.background)
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
                Text(viewModel.resources.sessionFinishAll)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(viewModel.resources.background)
            }).frame(width: 225, height: 44, alignment: .center)
                .background(viewModel.resources.buttonBackground)
                .cornerRadius(8)
        }
        .popup(isPresented: $isSelected,
               type: .toast,
               position: .bottom,
               closeOnTap: false,
               closeOnTapOutside: true,
               backgroundColor: viewModel.resources.backggroundFodding) {
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
                       Text(viewModel.resources.sessionFinishOne)
                           .font(.system(size: 15, weight: .bold))
                   }
               }
               .toolbar(.hidden, for: .tabBar)
    }
}
