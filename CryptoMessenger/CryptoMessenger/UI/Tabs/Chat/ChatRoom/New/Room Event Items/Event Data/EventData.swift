import SwiftUI

struct EventData: Identifiable, ViewGeneratable {
    let id = UUID()
    let date: String
    let dateColor: Color
    let backColor: Color
    let isFromCurrentUser: Bool
    let readData: any ViewGeneratable

    init(
        date: String,
        isFromCurrentUser: Bool,
        dateColor: Color = .manatee,
        backColor: Color = .clear,
        readData: any ViewGeneratable
    ) {
        self.date = date
        self.isFromCurrentUser = isFromCurrentUser
        self.dateColor = dateColor
        self.backColor = backColor
        self.readData = readData
    }

    // MARK: - ViewGeneratable

    func view() -> AnyView {
        EventDataView(
            model: self,
            readData: readData.view()
        ).anyView()
    }
}
