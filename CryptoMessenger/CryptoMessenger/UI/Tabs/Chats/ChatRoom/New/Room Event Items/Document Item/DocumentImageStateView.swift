import SwiftUI

// MARK: - DocumentImageState

struct DocumentImageStateView: View {
    
    @Binding var state: DocumentImageState
    var circleColor: Color
    @State private var isLoading: Bool
    
    init(state: Binding<DocumentImageState>,
         circleColor: Color = .dodgerBlue,
         isLoading: Bool = false) {
        self._state = state
        self.circleColor = circleColor
        self.isLoading = isLoading
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if state == .hasBeenDownloadPhoto {
                EmptyView()
            } else {
                Circle()
                    .frame(width: 44, height: 44)
                    .foreground(circleColor)
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
}
