import SwiftUI

// MARK: - AnotherAppDataView

struct AnotherAppDataView: View {

    // MARK: - Internal Properties

    var appData: AnotherAppData

    // MARK: - Body

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .inset(by: 1)
                    .stroke(Color.romanSilver, lineWidth: 1)
                    .frame(width: 54,
                           height: 54)
                Image(uiImage: appData.image)
                    .resizable()
                    .frame(width: 48,
                           height: 48)
            }
            Text(appData.name)
                .font(.subheadlineRegular15)
        }
    }
}
