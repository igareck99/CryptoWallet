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
            item.tapped ? R.image.answers.upsideArrow.image: R.image.answers.downsideArrow.image
        }
    }
}

// MARK: - AnswerAdditionalCellView

struct AnswerAdditionalCellView: View {

    // MARK: - Internal Properties

    var text: String

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center) {
            Text(text)
                .font(.regular(16))
                .frame(minHeight: 24,
                       maxHeight: 44,
                       alignment: .leading)
            Spacer()
        }
    }
}

// MARK: - AnswerView

struct AnswerView: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: AnswersViewModel
    @State private var tappedCell: Int?

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Divider().padding(.top, 16)
            List {
                ForEach(0...viewModel.listData.count - 1, id: \.self) { index in
                    AnswerCellView(item: viewModel.listData[index])
                        .background(.white())
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.listData[index].tapped.toggle()
                        }
                    if viewModel.listData[index].tapped {
                        ForEach(viewModel.listData[index].details) { item in
                            AnswerAdditionalCellView(text: item.text)
                                .background(.lightBlue())
                                .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .listStyle(.inset)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(R.string.localizable.additionalMenuQuestions())
                    .font(.bold(15))
            }
        }
    }
}

// MARK: - SessionListView_Previews

struct AV_Previews: PreviewProvider {
    static var previews: some View {
        AnswerAdditionalCellView(text: R.string.localizable.answersNotesShare())
    }
}
