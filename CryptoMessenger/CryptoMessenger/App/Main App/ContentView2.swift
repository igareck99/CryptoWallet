import SwiftUI

struct ContentView2<ViewModel: RootViewModelable>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Button("ContentView2") {
            viewModel.state = .content2
        }
    }
}
