import SwiftUI

// MARK: - ContactInfoView

struct ContactInfoView: View {

    // MARK: - Internal Properties

    var viewModel = ContactInfoViewModel()
    var data: ChatContactInfo

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showUploadImage = false

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
                Text(viewModel.resources.closeText)
                    .font(.system(size: 15, weight: .bold))                    .foreground(.dodgerBlue)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
                Text(viewModel.resources.phoneText)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(viewModel.resources.titleColor)
                Spacer()
                Text("")
                    .frame(width: 40)
            }
            .padding(.horizontal, 16)
            HStack(spacing: 16) {
                avatarView
                Text(data.name)
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal, 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.resources.phoneText)
                    .font(.system(size: 13, weight: .medium))
                Text(data.phone ?? "")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(viewModel.resources.buttonBackground)
                Divider()
            }
            .padding(.leading, 24)
            Spacer()
        }
        .padding(.top, 40)
    }

    private var avatarView: some View {
        changeShowValue()
        return ZStack {
            AsyncImage(
                defaultUrl: data.url,
                placeholder: {
                    if showUploadImage {
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .background(viewModel.resources.avatarBackground)
                    } else {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .background(viewModel.resources.avatarBackground)
                            viewModel.resources.avatarImage
                        }
                    }
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

    // MARK: - Private Methods

    private func changeShowValue() {
        data.url?.isReachable(completion: { success in
            if success {
                showUploadImage = true
            } else {
                showUploadImage = false
            }
        })
    }
}

// MARK: - ChatContactInfo

struct ChatContactInfo {
    var name: String
    var phone: String?
    var url: URL?
}
