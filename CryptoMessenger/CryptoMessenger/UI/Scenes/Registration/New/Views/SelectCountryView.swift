import SwiftUI

struct SelectCountryView<Colors: RegistrationColorable>: View {

    var selectCountry: Binding<String>
    @StateObject var colors: Colors
    let didTapButton: VoidBlock

    var body: some View {
        HStack(spacing: 0) {
            Text(selectCountry.wrappedValue)
                .font(.system(size: 17))
                .foregroundColor(colors.selectCountryTextColor.wrappedValue)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.forward")
                .font(.system(size: 17))
                .foregroundColor(colors.selectCountryChevronColor.wrappedValue)
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .contentShape(Rectangle())
        .highPriorityGesture(
            TapGesture().onEnded { _ in
                didTapButton()
            }
        )
        .frame(height: 46)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colors.selectCountryBackColor.wrappedValue)
        )
    }
}
