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
        HStack(alignment: .center, spacing: 8) {
            action.data.image
                .resizable()
                .frame(width: 30, height: 30)
            action.data.text
                .font(.bodyRegular17)
                .foregroundColor(.chineseBlack)
            Spacer()
        }
        .padding(.leading, 16)
        .background(.white())
        .onTapGesture {
            action.onTap(action.data)
        }
        .frame(height: 57)
    }
}
