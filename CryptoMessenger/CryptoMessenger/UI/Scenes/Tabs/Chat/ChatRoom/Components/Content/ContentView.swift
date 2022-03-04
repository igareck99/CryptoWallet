import SwiftUI

// MARK: - ContentTabs

enum ContentTabs: CaseIterable, Identifiable {

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

struct ContentView: View {

    // MARK: - Internal Properties

    @Binding var chatData: ChatData

    // MARK: - Private Properties

    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedPhoto: URL?

    // MARK: - Body

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(selectedPhoto != nil ? nil : .white(), isBlured: false)
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
                    Text("Медиа, ссылки и документы")
                        .font(.bold(15))
                        .foreground(.black())
                }
            }
    }

    // MARK: - Body Properties

    private var content: some View {
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

    private var photosView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let gridLayout = GridItem(.flexible(maximum: .infinity), spacing: 1.5)
            LazyVGrid(columns: Array(repeating: gridLayout, count: 3), alignment: .center, spacing: 1.5) {
                ForEach(0..<chatData.media.count, id: \.self) { index in
                    VStack(spacing: 0) {
                        AsyncImage(
                            url: chatData.media[index],
                            placeholder: {
                                ZStack { Color(.lightBlue()) }
                            },
                            result: {
                                Image(uiImage: $0).resizable()
                            }
                        )
                            .scaledToFill()
                            .onTapGesture {
                                selectedPhoto = chatData.media[index]
                            }
                    }
                }
            }
        }
    }
}
