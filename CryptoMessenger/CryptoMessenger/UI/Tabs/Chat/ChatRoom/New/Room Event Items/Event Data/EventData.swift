import SwiftUI

struct EventData: Identifiable, ViewGeneratable {
    let id = UUID()
    let date: String
    let dateColor: Color
    let backColor: Color
    let readData: any ViewGeneratable

    init(
        date: String,
        dateColor: Color = .manatee,
        backColor: Color = .clear,
        readData: any ViewGeneratable
    ) {
        self.date = date
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
