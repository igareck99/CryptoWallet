import SwiftUI

public typealias Leading<V> = Group<V> where V: View
public typealias Trailing<V> = Group<V> where V: View
public typealias Top<V> = Group<V> where V: View

public enum MenuType {
    case slided /// hstacked
    case swiped /// zstacked
}

enum VisibleButton {
    case none
    case left
    case right
    case top
}

public struct SwipeAction<V1: View, V2: View>: ViewModifier {

    @Binding private var isSwiped: Bool
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none

    /**
     To detect if drag gesture is ended because of known issue that drag gesture onEnded not called:
     https://stackoverflow.com/questions/58807357/detect-draggesture-cancelation-in-swiftui
     */
    @GestureState private var dragGestureActive = false
    @State private var maxLeadingOffset: CGFloat = .zero
    @State private var minTrailingOffset: CGFloat = .zero
    @State private var contentWidth: CGFloat = .zero
    /**
     For lazy views: because of measuring size occurred every onAppear
     */
    @State private var maxLeadingOffsetIsCounted = false
    @State private var minTrailingOffsetIsCounted = false
    private let menuTyped: MenuType
    private let leadingSwipeView: Group<V1>?
    private let trailingSwipeView: Group<V2>?
    private let swipeColor: Color?
    private let action: (() -> Void)?

    init(
		menu: MenuType,
		swipeColor: Color? = nil,
		isSwiped: Binding<Bool>,
		@ViewBuilder _ content: @escaping () -> TupleView<(Leading<V1>, Trailing<V2>)>,
		action: (() -> Void)? = nil
	) {
        menuTyped = menu
        self.swipeColor = swipeColor
        _isSwiped = isSwiped
        leadingSwipeView = content().value.0
        trailingSwipeView = content().value.1
        self.action = action
    }

    init(
		menu: MenuType,
		swipeColor: Color? = nil,
		isSwiped: Binding<Bool>,
		@ViewBuilder leading: @escaping () -> V1,
		action: (() -> Void)? = nil
	) {
        menuTyped = menu
        self.swipeColor = swipeColor
        _isSwiped = isSwiped
        leadingSwipeView = Group { leading() }
        trailingSwipeView = nil
        self.action = action
    }

    init(
		menu: MenuType,
		swipeColor: Color? = nil,
		isSwiped: Binding<Bool>,
		@ViewBuilder trailing: @escaping () -> V2,
		action: (() -> Void)? = nil
	) {
        menuTyped = menu
        self.swipeColor = swipeColor
        _isSwiped = isSwiped
        trailingSwipeView = Group { trailing() }
        leadingSwipeView = nil
        self.action = action
    }

	func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }

	var leadingView: some View {
        leadingSwipeView
            .measureSize {
                if !maxLeadingOffsetIsCounted {
                    maxLeadingOffset += $0.width
                }
            }
            .onAppear {
                /**
                 maxLeadingOffsetIsCounted for of lazy views
                 */
                if #available(iOS 16, *) {
                    maxLeadingOffsetIsCounted = true
                }
            }
    }

    var trailingView: some View {
        trailingSwipeView
            .measureSize {
                if !minTrailingOffsetIsCounted {
                    minTrailingOffset = (abs(minTrailingOffset) + $0.width) * -1
                }
            }
            .onAppear {
                /**
                 maxLeadingOffsetIsCounted for of lazy views
                 */
                if #available(iOS 16, *) {
                    minTrailingOffsetIsCounted = true
                }
            }
    }

	var swipedMenu: some View {
        HStack(spacing: 0) {
            leadingView
            Spacer()
            trailingView
				.offset(x: -1 * minTrailingOffset + offset)
        }
    }

	var slidedMenu: some View {
        HStack(spacing: 0) {
            leadingView
                .offset(x: (-1 * maxLeadingOffset) + offset)
            Spacer()
            trailingView
                .offset(x: (-1 * minTrailingOffset) + offset)
        }
    }

	func gesturedContent(content: Content) -> some View {
        content
            .onChange(of: offset, perform: { newValue in
                print("slkasklasklas  \(newValue)")
            })
            .contentShape(Rectangle()) // otherwise swipe won't work in vacant area
            .offset(x: offset)
            .measureSize {
                contentWidth = $0.width
            }
            .gesture(
                DragGesture(minimumDistance: 15, coordinateSpace: .local)
                    .updating($dragGestureActive) { _, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        let totalSlide = value.translation.width + oldOffset
						guard Int(minTrailingOffset * 1.5) ... 0 ~= Int(totalSlide) else { return }
						offset = totalSlide

                    }.onEnded { _ in
						debugPrint("gesture is ended! \(offset)")
						guard abs(offset) > 10 else { withAnimation { reset() }; return }
						withAnimation { reset() }
						action?()
                    })
            .valueChanged(of: dragGestureActive) { newIsActiveValue in

                if isSwiped == false, newIsActiveValue {
                    isSwiped = true
                }

                if newIsActiveValue == false {
                    withAnimation {
                        if visibleButton == .none {
                            reset()
                        }
                    }
                }
            }
            .valueChanged(of: isSwiped) { value in
                if value {
                    withAnimation { reset() }
                    isSwiped = false
                }
            }
    }

    public func body(content: Content) -> some View {
		ZStack {
			swipeColor
			swipedMenu
			gesturedContent(content: content)
		}
		.frame(height: nil, alignment: .top)
    }
}


public struct SwipeAllEdgesAction<V1: View, V2: View>: ViewModifier {
    
    @Binding private var isSwiped: Bool
    @Binding var isGestureActive: Bool
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @GestureState private var dragGestureActive = false
    @State private var contentHeight: CGFloat = .zero
    @State private var visibleButton: VisibleButton = .none
    private let menuTyped: MenuType
    private let topSwipeView: Group<V1>?
    private let bottomSwipeView: Group<V2>?
    private let swipeColor: Color?
    private let action: (() -> Void)?
    @State private var maxTopOffsetIsCounted = false
    @State private var minBottomOffsetIsCounted = false
    @State private var maxTopOffset: CGFloat = .zero
    @State private var minBottomOffset: CGFloat = .zero

    // MARK: - Lifecycle

    init(
        menu: MenuType,
        isGestureActive: Binding<Bool>,
        swipeColor: Color? = nil,
        isSwiped: Binding<Bool>,
        @ViewBuilder top: @escaping () -> V1,
        action: (() -> Void)? = nil
    ) {
        menuTyped = menu
        self.swipeColor = swipeColor
        self._isGestureActive = isGestureActive
        _isSwiped = isSwiped
        topSwipeView = Group { top() }
        bottomSwipeView = nil
        self.action = action
    }
    
    init(
        menu: MenuType,
        isGestureActive: Binding<Bool>,
        swipeColor: Color? = nil,
        isSwiped: Binding<Bool>,
        @ViewBuilder bottom: @escaping () -> V2,
        action: (() -> Void)? = nil
    ) {
        menuTyped = menu
        self._isGestureActive = isGestureActive
        self.swipeColor = swipeColor
        _isSwiped = isSwiped
        topSwipeView = nil
        bottomSwipeView = Group { bottom() }
        self.action = action
    }
    
    // MARK: - Private methods
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    var swipedMenu: some View {
        VStack(spacing: 0) {
            topView
            Spacer()
            bottomView
                .offset(y: (-1 * minBottomOffset) + offset)
        }
    }
    
    var topView: some View {
        topSwipeView
            .measureSize {
                if maxTopOffsetIsCounted {
                    maxTopOffset += $0.height
                }
            }
            .onAppear {
                /**
                 maxTopOffsetIsCounted for of lazy views
                 */
                if #available(iOS 16, *) {
                    maxTopOffsetIsCounted = true
                }
            }
    }

    var bottomView: some View {
        bottomSwipeView
            .measureSize {
                if minBottomOffsetIsCounted {
                    minBottomOffset = (abs(minBottomOffset) + $0.height) * -1
                }
            }
            .onAppear {
                /**
                 minBottomOffsetIsCounted for of lazy views
                 */
                if #available(iOS 16, *) {
                    minBottomOffsetIsCounted = true
                }
            }
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            swipeColor
            swipedMenu
            gesturedContent(content: content)
        }
        .frame(width: nil, alignment: .top)
    }
    
    func gesturedContent(content: Content) -> some View {
        content
            .contentShape(Rectangle()) // otherwise swipe won't work in vacant area
            .offset(y: offset)
            .measureSize {
                contentHeight = $0.width
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .updating($dragGestureActive) { _, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        let totalSlide = value.translation.height + oldOffset
                        guard abs(value.startLocation.y) - abs(value.location.y) > 0 else {  return }
                        guard abs(totalSlide) < 75 else {
                            withAnimation { reset() }
                            action?()
                            return
                        }
//                        guard Int(minBottomOffset * 1.5) ... 0 ~= Int(totalSlide) else { return }
                        offset = totalSlide

                    }.onEnded { _ in
                        guard abs(offset) > 10 else { withAnimation { reset() }; return }
                        withAnimation { reset() }
                        action?()
                    })
            .valueChanged(of: dragGestureActive) { newIsActiveValue in

                if isSwiped == false, newIsActiveValue {
                    isSwiped = true
                }

                if newIsActiveValue == false {
                    withAnimation {
                        if visibleButton == .none {
                            reset()
                        }
                    }
                }
            }
            .valueChanged(of: isSwiped) { value in
                if value {
                    withAnimation { reset() }
                    isSwiped = false
                }
            }
    }

}
