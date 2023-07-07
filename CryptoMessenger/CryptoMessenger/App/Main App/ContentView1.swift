import SwiftUI

struct ContentView1<ViewModel: RootViewModelable>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Button("ContentView1") {
            viewModel.state = .content1
        }
    }
}
