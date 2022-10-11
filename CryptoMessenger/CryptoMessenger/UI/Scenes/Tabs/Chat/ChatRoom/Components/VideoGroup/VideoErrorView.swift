import SwiftUI

struct ErrorView: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    VStack {
      Text("What do you think could go wrong? 🤔")
            .font(.bold(15))
        .padding()
      Button {
        presentationMode.wrappedValue.dismiss()
      }
      label: {
        Text("Dismiss")
          .font(.bold(15))
      }
    }
  }
}

struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorView()
  }
}
