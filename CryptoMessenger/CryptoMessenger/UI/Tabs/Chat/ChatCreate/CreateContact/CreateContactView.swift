import SwiftUI
import Contacts

// MARK: - CreateContactView

struct CreateContactView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: CreateContactViewModel
    @State var nameSurnameText = ""
    @State var numberText = ""
    @State var selectedImage: UIImage?
    @State var selectedLocation: Place?
    @State private var showActionImageAlert = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false

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
                                    Text(viewModel.resources.profileFromGallery),
                                    action: switchImagePicker
                                ),
                                .default(
                                    Text(viewModel.resources.profileFromCamera),
                                    action: switchCameraPicker
                                )
                            ]
                )
            }
            .fullScreenCover(isPresented: $showCameraPicker,
                             content: {
                ImagePickerView(selectedImage: $selectedImage,
                                sourceType: .camera)
                .ignoresSafeArea()
            })
            .fullScreenCover(isPresented: $showImagePicker,
                             content: {
                ImagePickerView(selectedImage: $selectedImage)
                    .navigationBarTitle(Text(viewModel.resources.photoEditorTitle))
                    .navigationBarTitleDisplayMode(.inline)
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        R.image.navigation.backButton.image
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text(viewModel.resources.createActionNewContact)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(viewModel.resources.titleColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.contactsStore.createContact(selectedImage: selectedImage,
                                                              nameSurnameText: nameSurnameText,
                                                              numberText: numberText)
                        viewModel.popToRoot()
                    }, label: {
                        Text(viewModel.resources.profileDetailRightButton)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(numberText.isEmpty ? viewModel.resources.textColor : viewModel.resources.buttonBackground)
                    })
                    .disabled(numberText.isEmpty)
                }
            }
    }

    private var content: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.top, 16)
            HStack(alignment: .center, spacing: 12) {
                if selectedImage != nil {
                    ZStack {
                        Image(uiImage: selectedImage ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60,
                                   height: 60)
                            .cornerRadius(30)
                        R.image.profileDetail.whiteCamera.image
                            .frame(width: 26,
                                   height: 21)
                    }
                    .onTapGesture {
                        showActionImageAlert = true
                    }
                } else {
                    ZStack {
                        Circle()
                            .fill(viewModel.resources.buttonBackground)
                            .frame(width: 60, height: 60)
                        R.image.profileDetail.whiteCamera.image
                            .frame(width: 26,
                                   height: 21)
                    }
                    .onTapGesture {
                        showActionImageAlert = true
                    }
                }
                ZStack(alignment: .topLeading) {
                    TextField("", text: $nameSurnameText)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                        .frame(height: 44)
                        .background(viewModel.resources.textBoxBackground)
                        .cornerRadius(8)
                    if nameSurnameText.isEmpty {
                        Text(viewModel.resources.facilityApproveNameSurname)
                            .foregroundColor(viewModel.resources.textColor)
                            .padding(.top, 12)
                            .padding(.leading, 16)
                            .disabled(true)
                            .allowsHitTesting(false)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 16)
            Text(viewModel.resources.createActionContactData.uppercased())
                .foregroundColor(viewModel.resources.textColor)
                .font(.system(size: 12, weight: .semibold))
                .padding(.leading, 16)
                .padding(.top, 24)
            VStack(spacing: 12) {
                IPhoneNumberField(nil,
                                  text: $numberText)
                    .flagHidden(false)
                    .prefixHidden(false)
                    .autofillPrefix(true)
                    .flagSelectable(true)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .font(.system(size: 15, weight: .regular))
                    .frame(height: 44)
                    .background(viewModel.resources.textBoxBackground)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
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
}
