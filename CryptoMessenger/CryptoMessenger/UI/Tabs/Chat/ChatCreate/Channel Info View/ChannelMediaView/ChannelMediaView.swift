import SwiftUI

// MARK: - ContentView

struct ChannelMediaView: View {

    // MARK: - Internal Properties

    @State var searchType = ChannelMediaTabs.media
    @StateObject var viewModel: ChannelMediaViewModel
    @State var showFile = false
    @State var selectedPhoto: URL?
    @State var isUploadFinished = false
    @State private var showImageViewer = false
    @State private var navBarHidden = false

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                // Оставил для информации по логике отображения нав бара
//                showNavBar()
            }
            .onChange(of: viewModel.selectedFile, perform: { newValue in
                guard let url = newValue.url else { return }
                self.viewModel.documentViewModel = DocumentViewerViewModel(url: url,
                                                                           isUploadFinished: $isUploadFinished,
                                                                           fileName: newValue.fileName)
            })
            .sheet(isPresented: $showFile, onDismiss: {
                showFile = false
            }, content: {
                if isUploadFinished {
                    PreviewControllerView(viewModel: viewModel.documentViewModel!)
                }
            })
            .fullScreenCover(isPresented: self.$showImageViewer,
                             content: {
                ImageViewerRemote(imageURL: $selectedPhoto,
                                  viewerShown: self.$showImageViewer,
                                  deleteActionAvailable: false,
                                  shareActionAvailable: false,
                                  onDelete: {
                }, onShare: {
                })
            })
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible, for: .navigationBar)
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
                    Text(viewModel.resources.channelInfoChannelMedia)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(viewModel.resources.titleColor)
                }
            }
    }

    // MARK: - Body Properties

    private var content: some View {
        VStack(alignment: .center, spacing: 0) {
            searchSelectView
            switch searchType {
            case .media:
                if viewModel.photos.isEmpty {
                    ChannelMediaEmptyState(image: R.image.media.noMedia.image,
                                           title: "Нет медиа",
                                           description: "Здесь будут медиафайлы канала")
                    .padding(.top, 219)
                } else {
                    photosView
                        .padding(.top, 2)
                }
            case .documents:
                if viewModel.files.isEmpty {
                    ChannelMediaEmptyState(image: R.image.media.noFiles.image,
                                           title: "Нет документов",
                                           description: "Здесь будут документы канала")
                    .frame(height: 195)
                    .padding(.top, 219 )
                } else {
                    List {
                        ForEach(0..<viewModel.files.count, id: \.self) { index in
                            ChannelDocumentView(showFile: $showFile,
                                                selectedFile: $viewModel.selectedFile,
                                                file: viewModel.files[index],
                                                viewModel: FileViewModel(url: viewModel.files[index].url,
                                                                         file: viewModel.files[index]))
                        }
                    }
                    .listStyle(.plain)
                    .background(viewModel.resources.backgroundFodding)
                    .padding(.bottom, 8)
                }
            case .links:
                EmptyView()
            }
            Spacer()
        }
    }

    private var searchSelectView: some View {
        HStack(spacing: 0) {
            ChannelMediaTypeView(selectedSearchType: $searchType,
                                 searchTypeCell: ChannelMediaTabs.media)
            ChannelMediaTypeView(selectedSearchType: $searchType,
                                 searchTypeCell: ChannelMediaTabs.documents )
        }
    }

    private var photosView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let gridLayout = GridItem(.flexible(maximum: .infinity), spacing: 1)
            LazyVGrid(columns: Array(repeating: gridLayout, count: 3), alignment: .center, spacing: 1) {
                ForEach(0..<viewModel.photos.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        let width = (UIScreen.main.bounds.width - 3) / 3
                        AsyncImage(
                            defaultUrl: viewModel.photos[index],
                            placeholder: {
                                ZStack { viewModel.resources.textBoxBackground }
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .frame(width: width, height: width)
                            .clipped()
                            .onTapGesture {
                                selectedPhoto = viewModel.photos[index]
                                showImageViewer = true
                            }
                    }
                }
            }
        }
    }
}
