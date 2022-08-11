import SwiftUI

// MARK: - AnotherAppTransitionView

struct AnotherAppTransitionView: View {

    // MARK: - Internal Properties

    @State var showShareView = false
    @Binding var showLocationTransition: Bool
    @StateObject var viewModel: AnotherApppTransitionViewModel

    // MARK: - Private Properties

    var hGridLayout = [ GridItem(.flexible()) ]

    // MARK: - Body

    var body: some View {
        content
        .onTapGesture {
            showLocationTransition.toggle()
        }
        .sheet(isPresented: $showShareView, content: {
            ShareTextView(text: viewModel.getLocationToShare())
                })
    }

    // MARK: - Private Properties

    private var content: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                VStack {
                    HStack {
                        Spacer()
                        dataView
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }
                .background(.white())
                .cornerRadius(14)
                Button(viewModel.sources.cancel) {
                    vibrate(.soft)
                    showLocationTransition.toggle()
                }
                .font(.regular(17))
                .foreground(.red())
                .frame(maxWidth: .infinity, idealHeight: 60, maxHeight: 60)
                .background(.white())
                .cornerRadius(14)
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 10)
        }
        .ignoresSafeArea()
    }

    private var dataView: some View {
        VStack {
            Text(viewModel.sources.openWith)
                .font(.bold(17))
            ScrollView(.horizontal) {
                LazyHGrid(rows: hGridLayout) {
                    ForEach(viewModel.resultAppList) { value in
                        AnotherAppDataView(appData: value)
                            .onTapGesture {
                                if viewModel.sideAppManager.canOpenMapApp(service: value.mapsApp,
                                                                          place: viewModel.place) {
                                    viewModel.sideAppManager.openSideApp(service: value.mapsApp,
                                                                         place: viewModel.place)
                                }
                            }
                    }
                }
            }
            Divider()
                .padding(.top, 8)
            Button {
                showShareView = true
            } label: {
                Text(viewModel.sources.shareWith)
                    .foreground(.blue())
                    .font(.semibold(19))
            }
            .padding(.bottom, 10)
        }
    }
}
