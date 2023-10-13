import SwiftUI

struct LoadInfoView: View {

    @StateObject var viewModel = LoadInfoViewModel()

    var model: LoadInfo {
        didSet {
            viewModel.update(url: model.url)
        }
    }

    var body: some View {
        HStack(spacing: .zero) {
            Text(viewModel.state)
                .font(.caption1Regular12)
                .foregroundColor(model.textColor)
                .padding(.horizontal, 4)
                .background(model.backColor)
                .clipShape(
                    RoundedRectangle(cornerRadius: 30)
                )
            Spacer()
        }
    }
}
