import SwiftUI

// MARK: - SelectContactCountryForCreateView

struct SelectContactCountryForCreateView<Colors: RegistrationColorable>: View {

    var selectCountry: Binding<String>
    var countryCode: Binding<String>
    @StateObject var colors: Colors
    let didTapButton: VoidBlock

    var body: some View {
        HStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                if !countryCode.wrappedValue.isEmpty {
                    Text(countryCode.wrappedValue)
                        .font(.regular(15))
                        .foregroundColor(colors.selectCountryTextColor.wrappedValue)
                }
                Text(selectCountry.wrappedValue)
                    .font(.regular(15))
                    .foregroundColor(colors.selectCountryTextColor.wrappedValue)
                    .lineLimit(1)
            }
            .padding(.leading, 16)
            Image(systemName: "chevron.forward")
                .font(.bodyRegular17)
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
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colors.selectCountryBackColor.wrappedValue)
        )
    }
}
