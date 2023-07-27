import Combine
import SwiftUI

protocol OtpViewColorable: ObservableObject {
    var codeStrokeColor: Binding<Color> { get set }
    var codeFillColor: Binding<Color> { get set }
    var codeTextColor: Binding<Color> { get set }
    var hyphenColor: Binding<Color> { get set }
}

struct OtpView<Colors: OtpViewColorable>: View {

    enum FocusField: Hashable {
        case field
        case none
    }

    @StateObject var colors: Colors
    @FocusState var focusedField: FocusField?
    @Binding var verificationCode: String
    let numberOfInputs: Int
    let hyphenOpacity: (Int) -> Double
    let strokeColor: (Int) -> Color
    let getPin: (Int) -> String
    let limitText: () -> Void

    private var backgroundTextField: some View {
        TextField("", text: $verificationCode)
            .frame(width: 0, height: 0, alignment: .center)
            .font(Font.system(size: 0))
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just($verificationCode)) { _ in
                limitText()
            }
            .focused($focusedField, equals: .field)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.focusedField = .field
                }
            }
            .padding()
    }

    var body: some View {
        ZStack(alignment: .center) {
            backgroundTextField
            HStack(spacing: 8) {
                ForEach(0..<numberOfInputs) { index in
                    ZStack {
                        Text(getPin(index))
                            .font(.system(size: 17))
                            .frame(width: 58, height: 46)
                            .foregroundColor(colors.codeTextColor.wrappedValue)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(strokeColor(index), lineWidth: 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(colors.codeFillColor.wrappedValue)
                                    )
                            )
                        Rectangle()
                            .frame(width: 6, height: 1)
                            .foregroundColor(colors.hyphenColor.wrappedValue)
                            .opacity(hyphenOpacity(index))
                    }
                }
            }
        }
    }
}
