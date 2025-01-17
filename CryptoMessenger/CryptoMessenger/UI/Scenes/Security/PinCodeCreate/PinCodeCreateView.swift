import SwiftUI

// MARK: - PinCodeCreateView

struct PinCodeCreateView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: PinCodeCreateViewModel
    @Environment(\.presentationMode) private var presentationMode
    var firstStack: [KeyboardButtonType] = [.number(1),
                                            .number(2),
                                            .number(3)
    ]
    var secondStack: [KeyboardButtonType] = [.number(4),
                                            .number(5),
                                            .number(6)
    ]
    var thirdStack: [KeyboardButtonType] = [.number(7),
                                            .number(8),
                                            .number(9)
    ]
    var fourthStack: [KeyboardButtonType] = [.empty,
                                            .number(0),
                                            .delete
    ]
    @State var dotesAnimation = 0

    // MARK: - Body

    var body: some View {
        VStack {
            VStack(spacing: 34) {
            Divider().padding(.top, 16)
        VStack(spacing: 60) {
            VStack(alignment: .center, spacing: 40) {
        VStack(alignment: .center, spacing: 16) {
            Text(viewModel.titleState)
                .font(.bold(21))
            Text(viewModel.descriptionState)
                .padding([.leading, .trailing], 24)
                .frame(minHeight: 42, maxHeight: 64)
                .font(.regular(15))
                .multilineTextAlignment(.center)
        }
            dotes
            .frame(minWidth: 134,
                   idealWidth: 134,
                   maxWidth: 134,
                   alignment: .center)
        }
            VStack(spacing: 25) {
            HStack(spacing: 33) {
                ForEach(firstStack, id: \.self) { item in
                    KeyboardButtonView(button: item)
                        .onTapGesture {
                            if !viewModel.finishScreen {
                                viewModel.keyboardAction(item: item)
                            }
                        }
                }
                }
            HStack(spacing: 33) {
                ForEach(secondStack, id: \.self) { item in
                    KeyboardButtonView(button: item)
                        .onTapGesture {
                            if !viewModel.finishScreen {
                                viewModel.keyboardAction(item: item)
                            }
                        }
                }
            }
                HStack(spacing: 33) {
                    ForEach(thirdStack, id: \.self) { item in
                        KeyboardButtonView(button: item)
                            .onTapGesture {
                                if !viewModel.finishScreen {
                                    viewModel.keyboardAction(item: item)
                                }
                            }
                    }
                }
                HStack(spacing: 33) {
                    ForEach(fourthStack, id: \.self) { item in
                        KeyboardButtonView(button: item)
                            .onTapGesture {
                                if !viewModel.finishScreen {
                                    viewModel.keyboardAction(item: item)
                                }
                            }
                    }
                    }
            }
        }
        }
            Spacer()
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
        .onChange(of: viewModel.finishScreen, perform: { value in
            if value {
                delay(0.85) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        })
        .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.securityPinCodeTitle())
                        .font(.bold(15))
                }
            }
    }

    private var dotes: some View {
        HStack(spacing: viewModel.dotesSpacing) {
            switch viewModel.errorPassword {
            case false:
                ForEach(viewModel.dotesValues, id: \.self) { item in
                    Circle()
                        .fill(item == 0 ? Color(.blue(0.1)): Color(.blue()))
                        .frame(width: 14, height: 14)
                }
            case true:
                ForEach(viewModel.dotesValues, id: \.self) { _ in
                    Circle()
                        .fill(Color(.red()))
                        .frame(width: 14, height: 14)
                }
                .onAppear {
                    withAnimation(.default) {
                        self.dotesAnimation += 1
                    }
                }
                .modifier(ShakeAnimation(animatableData: CGFloat(dotesAnimation)))
            }
        }
    }
}
