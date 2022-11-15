import SwiftUI
import Combine

// MARK: - View ()

extension View {

    // MARK: - Public Methods

    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        type: Popup<PopupContent>.PopupType = .`default`,
        position: Popup<PopupContent>.Position = .bottom,
        animation: Animation = Animation.easeOut(duration: 0.3),
        autohideIn: Double? = nil,
        dragToDismiss: Bool = true,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        backgroundColor: Color = Color.clear,
        dismissCallback: @escaping () -> Void = {},
        @ViewBuilder view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup(
                isPresented: isPresented,
                type: type,
                position: position,
                animation: animation,
                autohideIn: autohideIn,
                dragToDismiss: dragToDismiss,
                closeOnTap: closeOnTap,
                closeOnTapOutside: closeOnTapOutside,
                backgroundColor: backgroundColor,
                dismissCallback: dismissCallback,
                view: view)
        )
    }

    // MARK: - Internal Methods

    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }

    // MARK: - Fileprivate Methods

    @ViewBuilder
    fileprivate func addTap(if condition: Bool, onTap: @escaping () -> Void) -> some View {
        if condition {
            self.simultaneousGesture(
                TapGesture().onEnded {
                    onTap()
                }
            )
        } else {
            self
        }
    }
}

// MARK: - Popup

public struct Popup<PopupContent>: ViewModifier where PopupContent: View {

    // MARK: - PopupType

    public enum PopupType {

        // MARK: - Internal Methods

        func shouldBeCentered() -> Bool {
            switch self {
            case .`default`:
                return true
            default:
                return false
            }
        }

        // MARK: - Types

        case `default`
        case toast
        case floater(verticalPadding: CGFloat = 50)
    }

    // MARK: - Position

    public enum Position {

        // MARK: - Types

        case top
        case bottom
    }

    // MARK: - DragState

    private enum DragState {

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

        // MARK: - Types

        case inactive
        case dragging(translation: CGSize)
    }

    // MARK: - Private Properties

    /// Class reference for capturing a weak reference later in dispatch work holder.
    private var isPresentedRef: ClassReference<Binding<Bool>>?

    /// The rect of the hosting controller
    @State private var presenterContentRect: CGRect = .zero

    /// The rect of popup content
    @State private var sheetContentRect: CGRect = .zero

    /// Drag to dismiss gesture state
    @GestureState private var dragState = DragState.inactive

    /// Last position for drag gesture
    @State private var lastDragPosition: CGFloat = 0

    /// Show content for lazy loading
    @State private var showContent: Bool = false

    /// Should present the animated part of popup (sliding background)
    @State private var animatedContentIsPresented: Bool = false

    /// The offset when the popup is displayed
    private var displayedOffset: CGFloat {
        switch type {
        case .`default`:
            return  -presenterContentRect.midY + screenHeight/2
        case .toast:
            if position == .bottom {
                return screenHeight - presenterContentRect.midY - sheetContentRect.height/2
            } else {
                return -presenterContentRect.midY + sheetContentRect.height/2
            }
        case .floater(let verticalPadding):
            if position == .bottom {
                return screenHeight - presenterContentRect.midY - sheetContentRect.height/2 - verticalPadding
            } else {
                return -presenterContentRect.midY + sheetContentRect.height/2 + verticalPadding
            }
        }
    }

    /// The offset when the popup is hidden
    private var hiddenOffset: CGFloat {
        if position == .top {
            if presenterContentRect.isEmpty {
                return -1000
            }
            return -presenterContentRect.midY - sheetContentRect.height/2 - 5
        } else {
            if presenterContentRect.isEmpty {
                return 1000
            }
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
        }
    }

    /// The current offset, based on the **presented** property
    private var currentOffset: CGFloat {
        return animatedContentIsPresented ? displayedOffset : hiddenOffset
    }

    /// The current background opacity, based on the **presented** property
    private var currentBackgroundOpacity: Double {
        return animatedContentIsPresented ? 1.0 : 0.0
    }

    private var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }

    private var screenWidth: CGFloat {
        screenSize.width
    }

    private var screenHeight: CGFloat {
        screenSize.height
    }

    // MARK: - Internal Properties
    /// Tells if the sheet should be presented or not
    @Binding var isPresented: Bool

    var type: PopupType
    var position: Position

    var animation: Animation

    /// If nil - niver hides on its own
    var autohideIn: Double?

    /// Should close on tap - default is `true`
    var closeOnTap: Bool

    /// Should allow dismiss by dragging
    var dragToDismiss: Bool

    /// Should close on tap outside - default is `true`
    var closeOnTapOutside: Bool

    /// Background color for outside area - default is `Color.clear`
    var backgroundColor: Color

    /// is called on any close action
    var dismissCallback: () -> Void

    var view: () -> PopupContent

    /// holder for autohiding dispatch work (to be able to cancel it when needed)
    var dispatchWorkHolder = DispatchWorkHolder()

    // MARK: - Lifecycle

    init(isPresented: Binding<Bool>,
         type: PopupType,
         position: Position,
         animation: Animation,
         autohideIn: Double?,
         dragToDismiss: Bool,
         closeOnTap: Bool,
         closeOnTapOutside: Bool,
         backgroundColor: Color,
         dismissCallback: @escaping () -> Void,
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self.type = type
        self.position = position
        self.animation = animation
        self.autohideIn = autohideIn
        self.dragToDismiss = dragToDismiss
        self.closeOnTap = closeOnTap
        self.closeOnTapOutside = closeOnTapOutside
        self.backgroundColor = backgroundColor
        self.dismissCallback = dismissCallback
        self.view = view
        self.isPresentedRef = ClassReference(self.$isPresented)
    }

    // MARK: - Private Body Properties

    private func main(content: Content) -> some View {
        ZStack {
            content
                .frameGetter($presenterContentRect)

            backgroundColor
                .applyIf(closeOnTapOutside) { view in
                    view.contentShape(Rectangle())
                }
                .addTap(if: closeOnTapOutside) {
                    dismiss()
                }
                .edgesIgnoringSafeArea(.all)
                .opacity(currentBackgroundOpacity)
                .animation(animation)
        }
        .overlay(sheet())
    }

    private func onDragEnded(drag: DragGesture.Value) {
        let reference = sheetContentRect.height / 3
        if (position == .bottom && drag.translation.height > reference) ||
            (position == .top && drag.translation.height < -reference) {
            lastDragPosition = drag.translation.height
            withAnimation {
                lastDragPosition = 0
            }
            dismiss()
        }
    }

    private func appearAction(isPresented: Bool) {
        if isPresented {
            showContent = true
            DispatchQueue.main.async {
				view().hideTabBar()
                animatedContentIsPresented = true
            }
        } else {
            animatedContentIsPresented = false
			view().showTabBar()
        }
    }

    private func dismiss() {
        dispatchWorkHolder.work?.cancel()
        isPresented = false
        dismissCallback()
    }

    // MARK: - Public Body Properties

    public func body(content: Content) -> some View {
        Group {
            if showContent {
                main(content: content)
            } else {
                content
            }
        }
        .valueChanged(value: isPresented) { isPresented in
            appearAction(isPresented: isPresented)
        }
    }

    // MARK: - Internal Body Properties

    /// This is the builder for the sheet content
    func sheet() -> some View {

        // if needed, dispatch autohide and cancel previous one
        if let autohideIn = autohideIn {
            dispatchWorkHolder.work?.cancel()

            // Weak reference to avoid the work item capturing the struct,
            // which would create a retain cycle with the work holder itself.

            let block = dismissCallback
            dispatchWorkHolder.work = DispatchWorkItem(block: { [weak isPresentedRef] in
                isPresentedRef?.value.wrappedValue = false
                block()
            })
            if isPresented, let work = dispatchWorkHolder.work {
                DispatchQueue.main.asyncAfter(deadline: .now() + autohideIn, execute: work)
            }
        }

        let sheet = ZStack {
            self.view()
                .addTap(if: closeOnTap) {
                    dismiss()
                }
                .frameGetter($sheetContentRect)
                .frame(width: screenWidth)
                .offset(x: 0, y: currentOffset)
                .animation(animation)
        }

        let drag = DragGesture()
            .updating($dragState) { drag, state, _ in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)

        return sheet
            .applyIf(dragToDismiss) {
                $0.offset(y: dragOffset())
                    .simultaneousGesture(drag)
            }
    }

    func dragOffset() -> CGFloat {
        if (position == .bottom && dragState.translation.height > 0) ||
           (position == .top && dragState.translation.height < 0) {
            return dragState.translation.height
        }
        return lastDragPosition
    }
}

// MARK: - DispatchWorkHolder

final class DispatchWorkHolder {

    // MARK: - Internal Properties

    var work: DispatchWorkItem?
}

// MARK: - ClassReference

private final class ClassReference<T> {

    // MARK: - Internal Properties

    var value: T

    // MARK: - Lifecycle

    init(_ value: T) {
        self.value = value
    }
}

// MARK: - View ()

extension View {

    // MARK: - Fileprivate Methods

    @ViewBuilder
    fileprivate func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        self.onChange(of: value, perform: onChange)
    }
}

// MARK: - View ()

extension View {

    // MARK: - Internal Methods

    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

// MARK: - FrameGetter

struct FrameGetter: ViewModifier {

    // MARK: - Internal Properties

    @Binding var frame: CGRect

    // MARK: - Internal Methods

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = rect
                        }
                    }
                    return AnyView(EmptyView())
                }
            )
    }
}
