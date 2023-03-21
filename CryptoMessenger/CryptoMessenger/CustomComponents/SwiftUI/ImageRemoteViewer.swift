import SwiftUI
import UIKit
import Combine
// swiftlint:disable all

// MARK: - ImageViewerRemote

@available(iOS 13.0, *)
public struct ImageViewerRemote: View {

    // MARK: - Internal Properties
    
    @State var selectedItem: Int
    @Binding var viewerShown: Bool
    @Binding var imageURL: URL?
    @State var httpHeaders: [String: String]?
    var urls: [URL?]

    @State var dragOffset: CGSize = CGSize.zero
    @State var dragOffsetPredicted: CGSize = CGSize.zero
    private let deleteActionAvailable: Bool

    // MARK: - Private Properties

    private let onDelete: () -> Void
    private let onShare: () -> Void

    // MARK: - Lifecycle

    public init(selectedItem: Int = 0,
                imageURL: Binding<URL?>,
                viewerShown: Binding<Bool>,
                deleteActionAvailable: Bool = true,
                urls: [URL?] = [],
                onDelete: @escaping () -> Void,
                onShare: @escaping () -> Void) {
        self._selectedItem = State(initialValue: selectedItem)
        _imageURL = imageURL
        _viewerShown = viewerShown
        self.deleteActionAvailable = deleteActionAvailable
        self.urls = urls
        self.onDelete = onDelete
        self.onShare = onShare
    }

    @ViewBuilder
    public var body: some View {
        VStack {
            if(viewerShown) {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { self.viewerShown = false }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.system(size: UIFontMetrics.default.scaledValue(for: 24)))
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
                                        .offset(y: self.dragOffset.height)
                                        .pinchToZoom()
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color(red: 0.12, green: 0.12, blue: 0.12, opacity: (1.0 - Double(abs(self.dragOffset.width) + abs(self.dragOffset.height)) / 1000)).edgesIgnoringSafeArea(.all))
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
                                        if((abs(self.dragOffset.height) + abs(self.dragOffset.width) > 570) || ((abs(self.dragOffsetPredicted.height)) / (abs(self.dragOffset.height)) > 3) || ((abs(self.dragOffsetPredicted.width)) / (abs(self.dragOffset.width))) > 3) {
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
                        .background(Color(red: 0.12, green: 0.12, blue: 0.12, opacity: (1.0 - Double(abs(self.dragOffset.width) + abs(self.dragOffset.height)) / 1000)).edgesIgnoringSafeArea(.all))
                        .zIndex(1)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: { onShare() }) {
                                R.image.photoEditor.share.image
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.system(size: UIFontMetrics.default.scaledValue(for: 24)))
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                            Spacer()
                            if deleteActionAvailable {
                                Button(action: { onDelete() }) {
                                    R.image.photoEditor.brush.image
                                        .foregroundColor(Color(UIColor.white))
                                        .font(.system(size: UIFontMetrics.default.scaledValue(for: 24)))
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
                .onAppear() {
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

// MARK: - PinchZoomView

class PinchZoomView: UIView {
    
    // MARK: - Internal Properties

    weak var delegate: PinchZoomViewDelgate?
    
    // MARK: - Private Properties

    private(set) var scale: CGFloat = 0 {
        didSet {
            delegate?.pinchZoomView(self, didChangeScale: scale)
        }
    }

    private(set) var anchor: UnitPoint = .center {
        didSet {
            delegate?.pinchZoomView(self, didChangeAnchor: anchor)
        }
    }

    private(set) var offset: CGSize = .zero {
        didSet {
            delegate?.pinchZoomView(self, didChangeOffset: offset)
        }
    }

    private(set) var isPinching: Bool = false {
        didSet {
            delegate?.pinchZoomView(self, didChangePinching: isPinching)
        }
    }

    private var startLocation: CGPoint = .zero
    private var location: CGPoint = .zero
    private var numberOfTouches: Int = 0

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private Methods

    @objc private func pinch(gesture: UIPinchGestureRecognizer) {

        switch gesture.state {
        case .began:
            isPinching = true
            startLocation = gesture.location(in: self)
            anchor = UnitPoint(x: startLocation.x / bounds.width, y: startLocation.y / bounds.height)
            numberOfTouches = gesture.numberOfTouches

        case .changed:
            if gesture.numberOfTouches != numberOfTouches {
                // If the number of fingers being used changes, the start location needs to be adjusted to avoid jumping.
                let newLocation = gesture.location(in: self)
                let jumpDifference = CGSize(width: newLocation.x - location.x, height: newLocation.y - location.y)
                startLocation = CGPoint(x: startLocation.x + jumpDifference.width, y: startLocation.y + jumpDifference.height)

                numberOfTouches = gesture.numberOfTouches
            }

            scale = gesture.scale

            location = gesture.location(in: self)
            offset = CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)

        case .ended, .cancelled, .failed:
            withAnimation(.interactiveSpring()) {
                 isPinching = false
                 scale = 1.0
                 anchor = .center
                 offset = .zero
             }
        default:
            break
        }
    }

}

// MARK: - PinchZoomViewDelgate(AnyObject)

protocol PinchZoomViewDelgate: AnyObject {
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangePinching isPinching: Bool)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeScale scale: CGFloat)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeAnchor anchor: UnitPoint)
    func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeOffset offset: CGSize)
}

// MARK: - PinchZoom

struct PinchZoom: UIViewRepresentable {
    
    // MARK: - Internal Properties

    @Binding var scale: CGFloat
    @Binding var anchor: UnitPoint
    @Binding var offset: CGSize
    @Binding var isPinching: Bool

    // MARK: - Internal Methods

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView()
        pinchZoomView.delegate = context.coordinator
        return pinchZoomView
    }

    func updateUIView(_ pageControl: PinchZoomView, context: Context) { }

    class Coordinator: NSObject, PinchZoomViewDelgate {
        var pinchZoom: PinchZoom

        init(_ pinchZoom: PinchZoom) {
            self.pinchZoom = pinchZoom
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangePinching isPinching: Bool) {
            pinchZoom.isPinching = isPinching
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeScale scale: CGFloat) {
            pinchZoom.scale = scale
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeAnchor anchor: UnitPoint) {
            pinchZoom.anchor = anchor
        }

        func pinchZoomView(_ pinchZoomView: PinchZoomView, didChangeOffset offset: CGSize) {
            pinchZoom.offset = offset
        }
    }
}

// MARK: - PinchToZoom(ViewModifier)

struct PinchToZoom: ViewModifier {

    // MARK: - Internal Properties

    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching: Bool = false

    // MARK: - Internal Methods

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .offset(offset)
            .overlay(PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching))
    }
}

extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoom())
    }
}
