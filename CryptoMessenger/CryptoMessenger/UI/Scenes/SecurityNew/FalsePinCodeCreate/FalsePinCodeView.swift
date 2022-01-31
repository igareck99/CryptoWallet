import SwiftUI

// MARK: - FalsePinCodeView

struct FalsePinCodeView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: FalsePinCodeViewModel
    var firstStack = [KeyboardButtonType.number(1),
                                  KeyboardButtonType.number(2),
                                  KeyboardButtonType.number(3)]
    var secondStack = [KeyboardButtonType.number(4),
                                  KeyboardButtonType.number(5),
                                  KeyboardButtonType.number(6)]
    var thirdStack = [KeyboardButtonType.number(7),
                                  KeyboardButtonType.number(8),
                                  KeyboardButtonType.number(9)]
    var fourthStack = [
        KeyboardButtonType.empty,
        KeyboardButtonType.number(0),
        KeyboardButtonType.delete
    ]
    @State private var descriptionState = R.string.localizable.pinCodeFalseText()
    @State private var repeatState = false
    @State private var enteredPassword: [Int] = []
    @State private var repeatPassword: [Int] = []
    @State private var dotesValues = Array(repeating: 0, count: 5)
    @State private var errorPassword = false

    // MARK: - Body

    var body: some View {
        VStack {
            VStack(spacing: 34) {
            Divider().padding(.top, 16)
        VStack(spacing: 60) {
        VStack(spacing: 40) {
        VStack(alignment: .center, spacing: 16) {
            Text(R.string.localizable.pinCodeFalseTitle())
                .font(.bold(21))
            Text(descriptionState)
                .font(.regular(15))
                .multilineTextAlignment(.center)
                .padding(.leading, 24)
                .padding(.trailing, 6)
                .frame(height: 64)
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
                            keyboardAction(item: item)
                        }
                }
                }
            HStack(spacing: 33) {
                ForEach(secondStack, id: \.self) { item in
                    KeyboardButtonView(button: item)
                        .onTapGesture {
                            keyboardAction(item: item)
                        }
                }
            }
                HStack(spacing: 33) {
                    ForEach(thirdStack, id: \.self) { item in
                        KeyboardButtonView(button: item)
                            .onTapGesture {
                                keyboardAction(item: item)
                            }
                    }
                }
                HStack(spacing: 33) {
                    ForEach(fourthStack, id: \.self) { item in
                        KeyboardButtonView(button: item)
                            .onTapGesture {
                                keyboardAction(item: item)
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
        .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(R.string.localizable.securityPinCodeTitle())
                        .font(.bold(15))
                }
            }
    }

    private var dotes: some View {
        HStack(spacing: 16) {
            switch errorPassword {
            case false:
                ForEach(dotesValues, id: \.self) { item in
                    Circle()
                        .fill(item == 0 ? Color(.blue(0.1)): Color(.blue()))
                        .frame(width: 14, height: 14)
                }
            case true:
                ForEach(dotesValues, id: \.self) { _ in
                    Circle()
                        .fill(Color(.red()))
                        .frame(width: 14, height: 14)
                }
            }
        }
    }


    // MARK: - Private Properties

    private func clearPassword() {
        repeatPassword = []
        enteredPassword = []
        dotesValues = Array(repeating: 0, count: 5)
        repeatState = false
    }

    private func keyboardAction(item: KeyboardButtonType) {
        switch item {
        case let .number(value):
            if repeatState == false {
                if enteredPassword.count < 5 {
                    enteredPassword.append(value)
                    guard let index = enteredPassword.lastIndex(of: value) else { return }
                    dotesValues[index] = 1
                }
                if enteredPassword.count == 5 {
                    descriptionState = R.string.localizable.pinCodeRepeatPassword()
                    vibrate()
                    dotesValues = Array(repeating: 0, count: 5)
                    repeatState = true
                }
            } else {
                if repeatPassword.count < 5 {
                    repeatPassword.append(value)
                    guard let index = repeatPassword.lastIndex(of: value) else { return }
                    dotesValues[index] = 1
                }
                if repeatPassword.count == 5 {
                    if repeatPassword == enteredPassword {
                        descriptionState = R.string.localizable.pinCodeSuccessPassword()
                        clearPassword()
                        let newPassword = enteredPassword
                            .compactMap { $0.description }
                            .joined(separator: "")
                        clearPassword()
                        viewModel.createPassword(item: newPassword)
                    } else {
                        errorPassword = true
                        descriptionState = R.string.localizable.pinCodeNotMatchPassword()
                        delay(1) {
                            errorPassword = false
                            clearPassword()
                            descriptionState = R.string.localizable.pinCodeFalseText()
                        }
                    }
                }
            }
        case .delete:
            if repeatState == false {
                let index = enteredPassword.count - 1
                if enteredPassword.count >= 1 {
                    enteredPassword.removeLast()
                    dotesValues[index] = 0
                }
            } else {
                let index = repeatPassword.count - 1
                if repeatPassword.count >= 1 {
                    repeatPassword.removeLast()
                    dotesValues[index] = 0
                }
            }
        default:
            break
        }
    }
}
