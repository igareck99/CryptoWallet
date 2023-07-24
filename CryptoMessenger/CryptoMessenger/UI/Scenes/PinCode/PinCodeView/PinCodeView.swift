import SwiftUI

// MARK: - PinCodeView

struct PinCodeView<ViewModel>: View where ViewModel: PinCodeViewModelDelegate {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) private var presentationMode
    let columns: [GridItem] = Array(repeating: .init(.fixed(80), spacing: 24), count: 3)

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
            .onChange(of: viewModel.disappearScreen) { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .actionSheet(isPresented: $viewModel.showRemoveSheet) {
                ActionSheet(title: Text(viewModel.sources.deletePasswordTitle),
                            message: Text(viewModel.sources.deletePasswordDescription),
                            buttons: [
                                .cancel(Text(viewModel.sources.cancel), action: {
                                    viewModel.setToStart()
                                }),
                                .destructive(
                                    Text(viewModel.sources.delete),
                                    action: viewModel.removePassword
                                )
                            ]
                )
            }
    }

    private var content: some View {
        VStack {
            Spacer()
            headerView
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 24) {
                ForEach(viewModel.gridItem, id: \.self) { item in
                    KeyboardButtonView(button: item)
                        .onTapGesture {
                            viewModel.keyboardAction(item: item)
                        }
                }
            }
                      .padding(.top, 56)
            Spacer()
        }
    }

    private var headerView: some View {
        VStack(spacing: 16) {
            viewModel.auraLogo
                .resizable()
                .frame(width: 60,
                       height: 60)
            Text(viewModel.title)
                .font(.regular(22))
                .padding(.top, 24)
            PinCodeDotes(colors: $viewModel.colors,
                         dotesAnimation: $viewModel.animation)
        }
    }
}
