import SwiftUI

// MARK: - ChatMediaTabs

enum ChatMediaTabs: CaseIterable, Identifiable {

    // MARK: - Types

    case media, links, documents

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var title: String {
        switch self {
        case .media:
            return "Медиа"
        case .links:
            return "Ссылки"
        case .documents:
            return "Документы"
        }
    }
}

// MARK: - ContentView

struct ChatMediaView: View {

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
                    PreviewControllerView(viewModel: viewModel.documentViewModel!)
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
                    Text(viewModel.sources.friendProfileMedia)
                        .font(.bold(15))
                        .foreground(.black())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    viewModel.sources.settingsButton
                }
            }
    }

    // MARK: - Body Properties

    private var content: some View {
        VStack(alignment: .center) {
            searchSelectView
            switch searchType {
            case .media:
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
            case .links:
                VStack {
                    List {
                        ForEach(0..<viewModel.links.count, id: \.self) { index in
                            LinkRow(previewURL: viewModel.links[index],
                                    redraw: self.$redrawPreview)
                                .frame(height: 279)
                                .padding(.vertical, 28)
                        }
                    }
                    .ignoresSafeArea()
                    .listStyle(.plain)
                    .background(.paleGray(0.1))
                }
            case .documents:
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
        }
    }

    private var searchSelectView: some View {
        HStack(spacing: 6) {
            ChatMediaTypeView(selectedSearchType: $searchType,
                              searchTypeCell: ChatMediaTabs.media )
            ChatMediaTypeView(selectedSearchType: $searchType,
                              searchTypeCell: ChatMediaTabs.links )
            ChatMediaTypeView(selectedSearchType: $searchType,
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
                            defaultUrl: viewModel.photos[index],
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
