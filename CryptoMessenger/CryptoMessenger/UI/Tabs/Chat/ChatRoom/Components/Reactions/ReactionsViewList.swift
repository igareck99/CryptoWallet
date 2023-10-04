import SwiftUI

// MARK: - ReactionsViewList

struct ReactionsViewList: View {

    // MARK: - Internal Properties

    @StateObject var viewModel: ReactionsViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            emotions
                .padding(.top, 16)
                .padding(.horizontal, 16)
            Divider()
                .padding(.top, 12)
            peopleList
                .padding(.top, 24)
                .padding(.horizontal, 16)
        }
    }

    // MARK: - Private properties

    private var emotions: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(0 ..< viewModel.reactions.count, id: \.self) { item in
                    ZStack {
                        Rectangle()
                            .fill(viewModel.resoures.avatarBackground)
                            .frame(width: 58, height: 42)
                            .cornerRadius(radius: 30, corners: .allCorners)
                        HStack(spacing: 4) {
                            Text(viewModel.reactionsKeys[item])
                                .frame(width: 24, height: 33)
                            Text(String(viewModel.reactionsValues[item]))
                        }
                    }
                    .onTapGesture {
						debugPrint("emotions \(item) : \(viewModel.reactionsKeys[item])")
                    }
                }
            }
        }
    }

    private var peopleList: some View {
        ScrollView(.vertical) {
            ForEach(viewModel.people) { item in
                HStack(alignment: .center, spacing: 12) {
                    item.avatar
                        .resizable()
                        .cornerRadius(radius: 45, corners: .allCorners)
                        .frame(width: 40, height: 40)
                    Text(item.name)
                        .font(.headlineBold17)
                    Spacer()
                }
            }
        }
    }
}
