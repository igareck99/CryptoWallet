import SwiftUI

// MARK: - CreateAction

enum CreateAction: CaseIterable, Identifiable {

    // MARK: - Types

    case newContact, groupChat, createChannel

    // MARK: - Internal Properties

    var id: String { UUID().uuidString }

    var text: Text {
        switch self {
        case .createChannel:
            return Text(R.string.localizable.createActionCreateChannel())
        case .newContact:
            return Text(R.string.localizable.createActionNewContact())
        case .groupChat:
            return Text(R.string.localizable.createActionGroupChat())
        }
    }

    var color: Color { .chineseBlack }

    var image: Image {
        switch self {
        case .createChannel:
            return R.image.chat.group.channel.image
        case .newContact:
            return R.image.chat.group.contact.image
        case .groupChat:
            return R.image.chat.group.group.image
        }
    }
}

// MARK: - CreateActionViewModel

struct CreateActionViewModel: Identifiable, ViewGeneratable {

    // MARK: - Internal Properties

    var id = UUID()
    let data: CreateAction
    let onTap: (CreateAction) -> Void

    // MARK: - ViewGeneratable

    @ViewBuilder
    func view() -> AnyView {
        CreateActionView(action: self)
            .anyView()
    }
}

// MARK: - CreateActionView

struct CreateActionView: View {

    // MARK: - Internal Properties

    let action: CreateActionViewModel

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                action.data.image
                action.data.text
                    .font(.bodyRegular17)
                    .foregroundColor(.chineseBlack)
                    .frame(height: 57)

                Spacer()
            }
        }
        .background(.white())
        .padding([.leading, .trailing], 16)
        .frame(height: 48)
        .onTapGesture {
            action.onTap(action.data)
        }
    }
}
