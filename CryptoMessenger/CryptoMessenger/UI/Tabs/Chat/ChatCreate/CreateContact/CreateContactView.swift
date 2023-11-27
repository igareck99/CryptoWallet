import SwiftUI
import Contacts

// MARK: - CreateContactView

struct CreateContactView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: CreateContactViewModel
    @State private var showActionImageAlert = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @FocusState private var keyboardFocused: Bool

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .actionSheet(isPresented: $showActionImageAlert) {
                ActionSheet(title: Text(""),
                            message: nil,
                            buttons: [
                                .cancel(),
                                .default(
                                    Text(viewModel.resources.profileFromGallery).font(.calloutRegular16),
                                    action: switchImagePicker
                                ),
                                .default(
                                    Text(viewModel.resources.profileFromCamera).font(.calloutRegular16),
                                    action: switchCameraPicker
                                )
                            ]
                )
            }
            .sheet(isPresented: $viewModel.isContryCodePicker, content: {
                CountryCodePicker(delegate: viewModel)
            })
            .fullScreenCover(isPresented: $showCameraPicker,
                             content: {
                ImagePickerView(selectedImage: $viewModel.selectedImage,
                                sourceType: .camera)
                .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                             content: {
                ImagePickerView(selectedImage: $viewModel.selectedImage)
                    .navigationBarTitle(Text(viewModel.resources.photoEditorTitle))
                    .navigationBarTitleDisplayMode(.inline)
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                createToolBar()
            }
    }
    
    private var avatarView: some View {
        HStack(alignment: .center, spacing: 12) {
            if viewModel.selectedImage != nil {
                ZStack(alignment: .center) {
                    Image(uiImage: viewModel.selectedImage ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60,
                               height: 60)
                        .cornerRadius(30)
                        .onTapGesture {
                            showActionImageAlert = true
                        }
                    R.image.profileDetail.whiteCamera.image
                        .resizable()
                        .frame(width: 26,
                               height: 21)
                }
            } else {
                ZStack {
                    Circle()
                        .fill(viewModel.resources.buttonBackground)
                        .frame(width: 60, height: 60)
                    R.image.profileDetail.whiteCamera.image
                        .resizable()
                        .frame(width: 26,
                               height: 21)
                }
                .onTapGesture {
                    showActionImageAlert = true
                }
            }
            ZStack(alignment: .topLeading) {
                TextField("", text: $viewModel.nameSurnameText)
                    .font(.bodyRegular17)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .frame(height: 44)
                    .background(viewModel.resources.textBoxBackground)
                    .cornerRadius(8)
                if viewModel.nameSurnameText.isEmpty {
                    Text(viewModel.resources.facilityApproveNameSurname)
                        .font(.bodyRegular17)
                        .foregroundColor(viewModel.resources.textColor)
                        .padding(.top, 12)
                        .padding(.leading, 16)
                        .disabled(true)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    private var phonesView: some View {
        VStack {
            SelectContactCountryForCreateView(selectCountry: $viewModel.selectedCountry,
                                              countryCode: $viewModel.countryCode, colors: viewModel.colors) {
                viewModel.didTapSelectCountry()
            }
            .padding(.horizontal, 16)
            InputPhoneCreateContactView(phonePlaceholder: "(___) ___-__-__",
                                        phone: $viewModel.phone,
                                        isPhoneNumberValid: $viewModel.isPhoneNumberValid,
                                        keyboardFocused: $keyboardFocused,
                                        onCountryPhoneUpdate: viewModel.onCountryPhoneUpdate,
                                        colors: viewModel.colors)
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }

    private var content: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.top, 16)
            avatarView
            .padding(.top, 24)
            .padding(.horizontal, 16)
            Text(viewModel.resources.createActionContactData.uppercased())
                .foregroundColor(Color(hex: "#768286"))
                .font(.regular(12))
                .padding(.leading, 16)
                .padding(.top, 24)
            phonesView
                .padding(.top, 8)
            Spacer()
        }
    }

    // MARK: - Private Methods

    private func switchImagePicker() {
        showImagePicker = true
    }

    private func switchCameraPicker() {
        showCameraPicker = true
    }
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                R.image.navigation.backButton.image
            })
        }
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.createActionNewContact)
                .font(.bodySemibold17)
                .foregroundColor(viewModel.resources.titleColor)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.createContact()
                viewModel.popToRoot()
            }, label: {
                Text(viewModel.resources.profileDetailRightButton)
                    .font(.bodySemibold17)
                    .foregroundColor(viewModel.nameSurnameText.isEmpty ? viewModel.resources.textColor : viewModel.resources.buttonBackground)
            })
            .disabled(viewModel.nameSurnameText.isEmpty)
        }
    }
}
