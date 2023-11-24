import SwiftUI

// MARK: - AnswerCellView

struct AnswerCellView: View {
    
    // MARK: - Internal Properties
    
    var item: AnswerItem
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Text(item.title)
                .font(.subheadlineRegular15)
                .frame(height: 24, alignment: .leading)
            Spacer()
            item.tapped ? R.image.answers.upsideArrow.image : R.image.answers.downsideArrow.image
        }
    }
}

// MARK: - AnswerView

struct AnswerView: View {
    
    // MARK: - Internal Properties
    
    @StateObject var viewModel: AnswersViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Body
    
    var body: some View {
        Divider().padding(.top, 16)
        List {
            ForEach(0...viewModel.listData.count - 1, id: \.self) { index in
                if viewModel.listData[safe: index]?.tapped == true, let item = viewModel.listData[safe: index] {
                        AnswerCellView(item: item)
                        .background(viewModel.resources.background)
                        .listRowSeparator(.visible)
                        .onTapGesture {
                            viewModel.listData[index].tapped.toggle()
                        }
                } else {
                    AnswerCellView(item: viewModel.listData[safe: index]!)
                        .background(viewModel.resources.background)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.listData[index].tapped.toggle()
                        }
                    
                }
                if viewModel.listData[safe: index]?.tapped == true, let item = viewModel.listData[safe: index] {
                    withAnimation(.linear(duration: 0.15)) {
                        ForEach(item.details) { item in
                            Text(item.text)
                                .font(.calloutRegular16)
                                .frame(minHeight: 24,
                                       maxHeight: 44,
                                       alignment: .leading)
                                .listRowSeparator(.hidden)
                        }
                        .listRowBackground(viewModel.resources.textBoxBackground)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            createToolBar()
        }
        
    }
    
    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func createToolBar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.resources.additionalMenuQuestions)
                .font(.bodySemibold17)
                .foregroundColor(.chineseBlack)
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                R.image.navigation.backButton.image
            }
        }
    }
}
