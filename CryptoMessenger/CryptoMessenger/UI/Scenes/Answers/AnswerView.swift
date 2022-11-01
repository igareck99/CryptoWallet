import SwiftUI

// MARK: - AnswerCellView

struct AnswerCellView: View {

    // MARK: - Internal Properties

    var item: AnswerItem

    // MARK: - Body

    var body: some View {
        HStack {
            Text(item.title)
                .font(.regular(15))
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

    // MARK: - Body

    var body: some View {
            Divider().padding(.top, 16)
            List {
                ForEach(0...viewModel.listData.count - 1, id: \.self) { index in
                    if viewModel.listData[index].tapped {
                        AnswerCellView(item: viewModel.listData[index])
                        .background(.white())
                        .listRowSeparator(.visible)
                        .onTapGesture {
                            viewModel.listData[index].tapped.toggle()
                        }
                    } else {
                        AnswerCellView(item: viewModel.listData[index])
                        .background(.white())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.listData[index].tapped.toggle()
                        }

                    }
                    if viewModel.listData[index].tapped {
                        withAnimation(.linear(duration: 0.15)) {
                            ForEach(viewModel.listData[index].details) { item in
                                Text(item.text)
                                    .font(.regular(16))
                                    .frame(minHeight: 24,
                                           maxHeight: 44,
                                           alignment: .leading)
                                    .listRowSeparator(.hidden)
                            }
                            .listRowBackground(Color(.lightBlue()))
                        }
                    }
                }
        }
            .listStyle(.plain)
        .onDisappear {
            showTabBar()
        }
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.additionalMenuQuestions())
                    .font(.bold(15))
            }
        }
    }
}
