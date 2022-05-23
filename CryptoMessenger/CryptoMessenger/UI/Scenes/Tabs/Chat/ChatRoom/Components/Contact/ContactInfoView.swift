import SwiftUI

// MARK: - ContactInfoView

struct ContactInfoView: View {

    // MARK: - Internal Properties

    var viewModel = ContactInfoViewModel()
    var data: ChatContactInfo

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Lifecycle

    init(data: ChatContactInfo) {
        self.data = data
    }

    // MARK: - Body

    var body: some View {
        content
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack(alignment: .leading, spacing: 40) {
            HStack(alignment: .center) {
                Text(viewModel.sources.closeText)
                    .font(.bold(15))
                    .foreground(.blue())
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
                Text(viewModel.sources.phoneText)
                    .font(.bold(15))
                    .foreground(.black())
                Spacer()
                Text("")
                    .frame(width: 40)
            }
            .padding(.horizontal, 16)
            HStack(spacing: 16) {
                avatarView
                Text(data.name)
                    .font(.semibold(17))
                Spacer()
            }
            .padding(.horizontal, 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.sources.phoneText)
                    .font(.medium(13))
                Text(data.phone ?? "")
                    .font(.semibold(15))
                    .foreground(.blue())
                Divider()
            }
            .padding(.leading, 24)
            Spacer()
        }
        .padding(.top, 40)
    }

    private var avatarView: some View {
        let thumbnail = ZStack {
            Circle()
                .frame(width: 80, height: 80)
                .background(.blue(0.1))
            viewModel.sources.avatarImage
        }

        return ZStack {
            AsyncImage(
                url: data.url,
                placeholder: {
                    thumbnail
                },
                result: {
                    Image(uiImage: $0).resizable()
                }
            )
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(40)
        }
    }
}

// MARK: - ChatContactInfo

struct ChatContactInfo {
    var name: String
    var phone: String?
    var url: URL?
}
