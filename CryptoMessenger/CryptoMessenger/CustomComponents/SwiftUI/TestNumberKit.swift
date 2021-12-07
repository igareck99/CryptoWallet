import SwiftUI
import PhoneNumberKit

struct ContentViewOwn: View {
  @State private var phoneNumber = "9511423367"

  var body: some View {
    VStack {
      VStack {
        HStack {
            PhoneTextField()
        }
        Separator()
      }.frame(height: 44)
       .padding(.top, 60)
      Spacer()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentViewOwn()
  }
}

struct PhoneTextField: UIViewRepresentable {

  func makeUIView(context: Context) -> MyGBTextField {
    let phoneNumberKit = PhoneNumberKit()
    let textField = MyGBTextField(withPhoneNumberKit: phoneNumberKit)
    textField.withDefaultPickerUI = true
    textField.withPrefix = false
    textField.withFlag = false
    textField.withExamplePlaceholder = false
    textField.placeholder = "Phone"
    textField.maxDigits = 10
    return textField
  }

  func updateUIView(_ view: MyGBTextField, context: Context) {

  }
}


class MyGBTextField: PhoneNumberTextField {

  override var defaultRegion: String {
    get {
      return "GER"
    }
    set { }
  }
}

struct Separator: View {
  let color: Color

  var body: some View {
    Divider()
      .overlay(color)
      .padding(.zero)
  }

  init(color: Color = Color("separator")) {
    self.color = color
  }
}
