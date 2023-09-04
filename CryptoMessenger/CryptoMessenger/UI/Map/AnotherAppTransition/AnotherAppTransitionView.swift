import SwiftUI

// MARK: - AnotherAppTransitionView

struct AnotherAppTransitionView: View {

    // MARK: - Internal Properties

    @State var showShareView = false
    @Binding var showLocationTransition: Bool
    @StateObject var viewModel: AnotherApppTransitionViewModel

    // MARK: - Private Properties

    var hGridLayout = [ GridItem(.flexible(minimum: 85)) ]

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
                    dataView
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                }
                .background(viewModel.resources.background)
                .cornerRadius(14)
                Button(viewModel.resources.cancel) {
                    vibrate(.soft)
                    showLocationTransition.toggle()
                }
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(viewModel.resources.negativeColor)
                .frame(maxWidth: .infinity, idealHeight: 60, maxHeight: 60)
                .background(viewModel.resources.background)
                .cornerRadius(14)
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 10)
        }
        .ignoresSafeArea()
    }

    private var dataView: some View {
        VStack {
            Text(viewModel.resources.openWith)
                .font(.system(size: 17, weight: .bold))
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
                .padding(.top, 16)
            Button {
                showShareView = true
            } label: {
                Text(viewModel.resources.shareWith)
                    .foregroundColor(viewModel.resources.buttonBackground)
                    .font(.system(size: 19, weight: .semibold))
            }
            .padding(.bottom, 10)
        }
    }
}
