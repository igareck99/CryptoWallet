import SwiftUI

// MARK: - ContactInfoView

struct ContactInfoView<ViewModel: ContactInfoViewDelegate>: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ViewModel
    var data: ChatContactInfo

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var showUploadImage = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
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
            .toolbar {
                makeToolBar()
            }
        }
    }

    @ToolbarContentBuilder
    private func makeToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text(viewModel.resources.closeText)
                .font(.system(size: 15, weight: .bold))
                .foreground(.dodgerBlue)
                .onTapGesture {
//                    presentationMode.wrappedValue.dismiss()
                    viewModel.onCloseTap()
                }
        }

        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.phoneText)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(viewModel.resources.titleColor)
        }
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
