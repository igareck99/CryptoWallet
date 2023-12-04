import Combine
import SwiftUI
import UIKit

struct ImageViewerRemote: View {

    // MARK: - Internal Properties

    @State var selectedItem: Int
    @Binding var viewerShown: Bool
    @Binding var imageURL: URL?
    @State var httpHeaders: [String: String]?
    @State var dragOffset: CGSize = .zero
    @State var dragOffsetPredicted: CGSize = .zero
    var urls: [URL?]
    private let deleteActionAvailable: Bool
    private let shareActionAvailable: Bool
    private let onDelete: () -> Void
    private let onShare: () -> Void

    // MARK: - Lifecycle

    init(
        selectedItem: Int = 0,
        imageURL: Binding<URL?>,
        viewerShown: Binding<Bool>,
        deleteActionAvailable: Bool = true,
        shareActionAvailable: Bool = true,
        urls: [URL?] = [],
        onDelete: @escaping () -> Void,
        onShare: @escaping () -> Void
    ) {
        self._selectedItem = State(initialValue: selectedItem)
        _imageURL = imageURL
        _viewerShown = viewerShown
        self.deleteActionAvailable = deleteActionAvailable
        self.shareActionAvailable = shareActionAvailable
        self.urls = urls
        self.onDelete = onDelete
        self.onShare = onShare
    }

    @ViewBuilder
    var body: some View {
        VStack {
            if viewerShown {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                self.viewerShown = false
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.title2Regular22)
                                    .padding()
                            }
                            .padding(.top, 64)
                            .padding(.trailing, 16)
                        }
                        Spacer()
                    }
                    .padding()
                    .zIndex(2)
                    if !urls.isEmpty {
                        TabView(selection: $selectedItem) {
                            ForEach(Array(urls.enumerated()), id: \.element) { index, value in
                                VStack {
                                    ZStack {
                                        AsyncImage(
                                            defaultUrl: value,
                                            placeholder: {
                                                ProgressView()
                                                    .frame(width: 48,
                                                           height: 48)
                                            },
                                            result: {
                                                Image(uiImage: $0)
                                                    .resizable()
                                            }
                                        )
                                        .aspectRatio(contentMode: .fit)
                                        .padding([.top, .bottom], 50)
                                        .offset(y: self.dragOffset.height)
                                        .pinchToZoom()
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(
                                    Color(
                                        red: 0.12,
                                        green: 0.12,
                                        blue: 0.12,
                                        opacity: (1.0 - Double(abs(self.dragOffset.width) + abs(self.dragOffset.height)) / 1000)
                                    ).edgesIgnoringSafeArea(.all)
                                )
                                .zIndex(1)
                                .tag(index)
                            }
                        }.tabViewStyle(.page(indexDisplayMode: .never))
                    } else {
                        VStack {
                            ZStack {
                                AsyncImage(
                                    defaultUrl: self.imageURL,
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: 48,
                                                   height: 48)
                                    },
                                    result: {
                                        Image(uiImage: $0)
                                            .resizable()
                                    }
                                )
                                .aspectRatio(contentMode: .fit)
                                .offset(y: self.dragOffset.height)
                                .rotationEffect(.init(degrees: Double(self.dragOffset.width / 30)))
                                .pinchToZoom()
                                .gesture(DragGesture()
                                    .onChanged { value in
                                        self.dragOffset = value.translation
                                        self.dragOffsetPredicted = value.predictedEndTranslation
                                    }
                                    .onEnded { value in
                                        debugPrint("value: \(value)")
                                        if (abs(self.dragOffset.height) + abs(self.dragOffset.width) > 570) ||
                                            ((abs(self.dragOffsetPredicted.height)) / (abs(self.dragOffset.height)) > 3) ||
                                            ((abs(self.dragOffsetPredicted.width)) / (abs(self.dragOffset.width))) > 3 {
                                            withAnimation(.spring()) {
                                                self.dragOffset = self.dragOffsetPredicted
                                            }
                                            self.viewerShown = false
                                            return
                                        }
                                        withAnimation(.interactiveSpring()) {
                                            self.dragOffset = .zero
                                        }
                                    }
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Color(
                                red: 0.12,
                                green: 0.12,
                                blue: 0.12,
                                opacity: (1.0 - Double(abs(self.dragOffset.width) + abs(self.dragOffset.height)) / 1000)
                            ).edgesIgnoringSafeArea(.all))
                        .zIndex(1)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            if shareActionAvailable {
                                Button {
                                    onShare()
                                } label: {
                                    R.image.photoEditor.share.image
                                        .foregroundColor(Color(UIColor.white))
                                        .font(.title2Regular22)
                                }
                                .padding(.leading, 16)
                                .padding(.bottom, 16)

                                Spacer()
                            }
                            if deleteActionAvailable {
                                Button {
                                    onDelete()
                                } label: {
                                    R.image.photoEditor.brush.image
                                        .foregroundColor(Color(UIColor.white))
                                        .font(.title2Regular22)
                                }
                                .padding(.trailing, 16)
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding()
                    .zIndex(2)
                }
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                .onAppear {
                    self.dragOffset = .zero
                    self.dragOffsetPredicted = .zero
                }
            }
        }
        .onChange(of: selectedItem, perform: { value in
            renewSelectedUrl(value)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func renewSelectedUrl(_ index: Int) {
        if urls.count > index {
            self.imageURL = urls[index]
        }
    }
}
