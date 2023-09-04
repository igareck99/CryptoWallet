import SwiftUI

struct Shimmer: ViewModifier {
    
    // MARK: - Private Properties
    
    @State private var phase = CGFloat(0)
    
    // MARK: - Internal Properties
    
    var duration = 1.5
    var bounce = false
    
    // MARK: - Content
    
    func body(content: Content) -> some View {
        content
            .modifier(
                AnimatedMask(phase: phase).animation(
                    .linear(duration: duration)
                    .repeatForever()
                )
            )
            .onAppear { phase = 0.8 }
    }
    
    // MARK: - AnimatedMask
    
    struct AnimatedMask: AnimatableModifier {
        
        // MARK: - Internal Properties
        
        var phase: CGFloat = 0
        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }
        
        // MARK: - Internal Methods
        
        func body(content: Content) -> some View {
            content
                .mask(GradientMask(phase: phase).scaleEffect(3))
        }
    }
    
    // MARK: - GradientMask
    
    struct GradientMask: View {
        
        // MARK: - Internal Properties
        
        let phase: CGFloat
        let centerColor: Color = .dodgerBlue
        let edgeColor: Color = .dodgerTransBlue
        
        // MARK: - Lifecycle
        
        var body: some View {
            LinearGradient(
                gradient:
                    Gradient(stops: [
                        .init(color: edgeColor, location: phase),
                        .init(color: centerColor, location: phase + 0.1),
                        .init(color: edgeColor, location: phase + 0.2)
                    ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
}

// MARK: - View (Shimmer)

extension View {
    @ViewBuilder func shimmering(
        active: Bool = true,
        duration: Double = 1.5,
        bounce: Bool = false
    ) -> some View {
        if active {
            modifier(Shimmer(duration: duration, bounce: bounce))
        } else {
            self
        }
    }
}
