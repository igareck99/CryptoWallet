import SwiftUI

// MARK: - FalsePinCodeView

struct FalsePinCodeView: View {

    // MARK: - Internal Properties

    @ObservedObject var viewModel: FalsePinCodeViewModel
    var dotesValues = [0, 0, 0, 0, 0]
    var enteredPassword: [Int] = []
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
            Text(R.string.localizable.pinCodeFalseText())
                .font(.regular(15))
                .multilineTextAlignment(.center)
                .padding(.leading, 24)
                .padding(.trailing, 6)
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
                            print(item)
                        }
                }
                }
            HStack(spacing: 33) {
                ForEach(secondStack, id: \.self) { item in
                    KeyboardButtonView(button: item)
                        .onTapGesture {
                            print(item)
                        }
                }
            }
                HStack(spacing: 33) {
                    ForEach(thirdStack, id: \.self) { item in
                        KeyboardButtonView(button: item)
                            .onTapGesture {
                                print(item)
                            }
                    }
                }
                HStack(spacing: 33) {
                    ForEach(fourthStack, id: \.self) { item in
                        KeyboardButtonView(button: item)
                            .onTapGesture {
                                print(item)
                            }
                    }
                    }
            }
        }
        }
            Spacer()
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
            ForEach(dotesValues, id: \.self) { item in
                Circle()
                    .fill(item == 0 ? Color(.blue(0.1)): Color(.blue()))
                    .frame(width: 14, height: 14)
            }
        }
    }

    // MARK: - Private Properties

    mutating func keyboardAction(item: KeyboardButtonType) {
        switch item {
        case let .number(value):
            if enteredPassword.count < 5 {
                enteredPassword.append(value)
            }
            for item in 0...enteredPassword.count {
                dotesValues[item] = 1
            }
        case .delete:
            guard let index = enteredPassword.lastIndex(of: 1) else { return }
            enteredPassword.remove(at: index)
        default:
            break
        }
    }
}
