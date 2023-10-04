import SwiftUI

// MARK: - SelectFeedImageView

struct SelectFeedImageView: View {

    // MARK: - Internal Properties

    let sourceType: (UIImagePickerController.SourceType) -> Void

    // MARK: - Body

    var body: some View {
        LazyVStack {
            ForEach(SelectFeedImageType.allCases, id: \.self) { type in
                HStack(alignment: .center, content: {
                    HStack(spacing: 16) {
                        type.image
                        Text(type.text)
                            .font(.calloutRegular16)
                    }
                    Spacer()
                })
                .padding(.horizontal, 16)
                .frame(height: 57)
                .onTapGesture {
                    sourceType(type.systemType)
                }
            }
        }
        .toolbar(.visible, for: .tabBar)
        .listStyle(.plain)
    }
}
