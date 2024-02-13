import SwiftUI

// MARK: - DocumentImageState

struct DocumentImageStateView: View {

    @Binding var state: DocumentImageState
    let viewType: DocumentImageStateType
    @State private var isLoading: Bool

    var circleColor: Color {
        if viewType == .file {
            return .dodgerBlue
        } else {
            return state.color
        }
    }
    
    init(state: Binding<DocumentImageState>,
         viewType: DocumentImageStateType,
         isLoading: Bool = false) {
        self._state = state
        self.viewType = viewType
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
