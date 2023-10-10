import SwiftUI

// MARK: - AudioEventStateView

struct AudioEventStateView: View {
    
    @Binding var state: AudioEventItemState
    @State private var isLoading = false
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .frame(width: 44, height: 44)
                .foreground(.dodgerBlue)
                .overlay {
                    if state == .loading {
                        Circle()
                            .trim(from: 0, to: 0.37)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 40, height: 40)
                            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                            .onAppear {
                                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                                    isLoading = true
                                }
                            }
                            .onDisappear {
                                isLoading = false
                            }
                    } else {
                        EmptyView()
                    }
                }
            state.image
        }
    }
}
