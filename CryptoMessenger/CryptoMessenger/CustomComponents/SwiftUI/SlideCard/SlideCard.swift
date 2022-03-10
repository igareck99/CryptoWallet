import SwiftUI

// MARK: - CardBackgroundStyle

enum CardBackgroundStyle {

    // MARK: - Types

    case solid, clear, blur
}

// MARK: - CardPosition

enum CardPosition: Equatable {

    // MARK: - Types

    case bottom, middle, top
    case custom(CGFloat)

    // MARK: - Internal Properties

    var offsetFromTop: CGFloat {
        switch self {
        case .bottom:
            return UIScreen.main.bounds.height
        case .middle, .top:
            return UIScreen.main.bounds.height - 558
        case let .custom(offset):
            return offset
        }
    }
}

// MARK: - SlideCard

struct SlideCard<Content>: View where Content: View {

    // MARK: - Private Properties

    @Binding private var defaultPosition: CardPosition
    @Binding private var backgroundStyle: CardBackgroundStyle
    private var content: () -> Content

    // MARK: - Lifecycle

    init(
        position: Binding<CardPosition> = .constant(.bottom),
        backgroundStyle: Binding<CardBackgroundStyle> = .constant(.solid),
        content: @escaping () -> Content
    ) {
        self.content = content
        self._defaultPosition = position
        self._backgroundStyle = backgroundStyle
    }

    // MARK: - Body

    var body: some View {
        ModifiedContent(
            content: content(),
            modifier: CardModifier(position: $defaultPosition, backgroundStyle: $backgroundStyle)
        )
    }
}

// MARK: - CardModifier

private struct CardModifier: ViewModifier {

    // MARK: - DragState

    enum DragState {

        // MARK: - Types

        case inactive
        case dragging(translation: CGSize)

        // MARK: - Internal Properties

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }

    // MARK: - Internal Properties

    @Binding var position: CardPosition
    @Binding var backgroundStyle: CardBackgroundStyle

    // MARK: - Private Properties

    @SwiftUI.Environment(\.colorScheme) private var colorScheme: ColorScheme
    @GestureState private var dragState: DragState = .inactive
    @State private var offset = CGSize.zero
    private let animation = Animation.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)

    // MARK: - Body

    func body(content: Content) -> some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, _ in
                state = .dragging(translation: drag.translation)
            }
            .onChanged {_ in
                self.offset = .zero
            }
            .onEnded(onDragEnded)

        return ZStack(alignment: .top) {
            ZStack(alignment: .top) {
                if backgroundStyle == .blur {
                    BlurView(style: colorScheme == .dark ? .dark : .extraLight)
                }

                if backgroundStyle == .clear {
                    Color.clear
                }

                if backgroundStyle == .solid {
                    colorScheme == .dark ? Color(.black()) : Color(.white())
                }

                HandleView()

                content
            }
            .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(x: 1, y: 1, anchor: .center)
        }
        .offset(y: max(0, position.offsetFromTop + dragState.translation.height))
        .animation((dragState.isDragging ? nil : animation))
        .gesture(drag)
    }

    // MARK: - Private Methods

    private func onDragEnded(drag: DragGesture.Value) {
        let higherStop: CardPosition
        let lowerStop: CardPosition
        let nearestPosition: CardPosition

        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        let offsetFromTopOfView = position.offsetFromTop + drag.translation.height

        if offsetFromTopOfView <= CardPosition.middle.offsetFromTop {
            higherStop = .top
            lowerStop = .middle
        } else {
            higherStop = .middle
            lowerStop = .bottom
        }

        if offsetFromTopOfView - higherStop.offsetFromTop < lowerStop.offsetFromTop - offsetFromTopOfView {
            nearestPosition = higherStop
        } else {
            nearestPosition = lowerStop
        }

        if dragDirection > 0 {
            position = lowerStop
        } else if dragDirection < 0 {
            position = higherStop
        } else {
            position = nearestPosition
        }
    }
}

// MARK: - HandleView

private struct HandleView: View {

    // MARK: - Internal Properties

    private let handleThickness = CGFloat(4)

    // MARK: - Body

    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness * 0.5)
            .frame(width: 31, height: handleThickness)
            .foreground(.darkGray(0.4))
            .padding(6)
    }
}
