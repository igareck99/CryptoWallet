import SwiftUI

// MARK: - ContentView

struct ChannelMediaView: View {

    // MARK: - Internal Properties

    @State var searchType = ChatMediaTabs.media
    @StateObject var viewModel: ChatMediaViewModel
    @State var showFile = false
    @State var selectedPhoto: URL?
    @State var redrawPreview = false
    @State var isUploadFinished = false

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Body

    var body: some View {
        content
            .onAppear {
                showNavBar()
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
                    PreviewControllerTestView(viewModel: viewModel.documentViewModel!)
                }
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(selectedPhoto != nil ? nil : .white(), isBlured: false)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        viewModel.sources.backButton
                    })
                }

                ToolbarItem(placement: .principal) {
                    Text("Медиа и документы")
                        .font(.bold(15))
                        .foreground(.black())
                }
            }
    }

    // MARK: - Body Properties

    private var content: some View {
        VStack(alignment: .center) {
            searchSelectView
            switch searchType {
            case .media:
                if viewModel.photos.isEmpty {
                    ChannelMediaEmptyState(image: R.image.media.noMedia.image,
                                           title: "Нет медиа",
                                           description: "Здесь будут медиафайлы канала")
                    .padding(.top, 219)
                } else {
                    ZStack {
                        photosView
                        if selectedPhoto != nil {
                            ZStack {
                                ImageViewer(
                                    selectedPhoto: $selectedPhoto,
                                    allImages: [],
                                    selectedImageID: ""
                                )
                                .navigationBarHidden(true)
                                .ignoresSafeArea()
                            }
                        }
                    }
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
                            ChatDocumentView(showFile: $showFile,
                                             selectedFile: $viewModel.selectedFile,
                                             file: viewModel.files[index])
                        }
                        .listRowBackground(Color(.paleGray(0.1)))
                    }
                    .ignoresSafeArea()
                    .listStyle(.plain)
                    .background(.paleGray(0.1))
                    Spacer()
                }
            case .links:
                EmptyView()
            }
            Spacer()
        }
    }

    private var searchSelectView: some View {
        HStack {
            ChannelMediaTypeView(selectedSearchType: $searchType,
                                 searchTypeCell: ChatMediaTabs.media)
            Spacer()
            ChannelMediaTypeView(selectedSearchType: $searchType,
                                 searchTypeCell: ChatMediaTabs.documents )
        }
    }

    private var photosView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let gridLayout = GridItem(.flexible(maximum: .infinity), spacing: 1.5)
            LazyVGrid(columns: Array(repeating: gridLayout, count: 3), alignment: .center, spacing: 1.5) {
                ForEach(0..<viewModel.photos.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        let width = (UIScreen.main.bounds.width - 3) / 3
                        AsyncImage(
                            url: viewModel.photos[index],
                            placeholder: {
                                ZStack { Color(.lightBlue()) }
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
                            }
                    }
                }
            }
        }
    }
}

// MARK: - ChannelMediaTypeView

struct ChannelMediaTypeView: View {

    // MARK: - Internal Properties

    @Binding var selectedSearchType: ChatMediaTabs
    @State var searchTypeCell: ChatMediaTabs

    // MARK: - Body

    var body: some View {
        VStack(spacing: 7) {
            Text(searchTypeCell.title,
                 [
                    .paragraph(.init(lineHeightMultiple: 1.15, alignment: .center)),
                    .font(.regular(13)),
                    .color(searchTypeCell == selectedSearchType ? .blue() : .darkGray())
                 ])
            Divider()
                .frame(width: UIScreen.main.bounds.width / 2 + 4,
                       height: searchTypeCell == selectedSearchType ? 2 : 1)
                .background(searchTypeCell == selectedSearchType ? .blue() : .lightGray ())
        }
        .frame(alignment: .center)
        .onTapGesture {
            withAnimation(.linear(duration: 0.35)) {
                selectedSearchType = searchTypeCell
            }
        }
    }
}
