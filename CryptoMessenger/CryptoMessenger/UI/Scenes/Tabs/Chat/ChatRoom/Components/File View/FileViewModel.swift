import Foundation
import Combine
import PDFKit

// MARK: - FileViewModel

final class FileViewModel: ObservableObject {

    // MARK: - Internal Properties

    @Published var sizeOfFile = ""
    @Published var date: String = ""
    @Published var fileImage = UIImage()
    let url: URL?
    let file: FileData

    // MARK: - Private Properties

    let remoteDataService = RemoteDataService()
    private var subscriptions = Set<AnyCancellable>()

    init(url: URL?,
         file: FileData = FileData.makeEmptyFile()) {
        self.url = url
        self.file = file
        getSize()
        getDateString()
        pdfThumbnail(url: self.url)
    }

    // MARK: - Private Methods

    private func getSize() {
        guard let url = url else {
            self.sizeOfFile = "0 MB"
            return
        }
        DispatchQueue.global(qos: .background).async {
            self.remoteDataService.fetchContentLength(for: url, httpMethod: .get) { contentLength in
                guard let length = contentLength else { return }
                var value = round(10 * Double(length) / 1024) / 10
                if value < 1000 {
                    self.sizeOfFile = String(value) + " KB"
                } else {
                    value = round(10 * Double(length) / 1024 / 1000) / 10
                    self.sizeOfFile = String(value) + " MB"
                }
            }
        }
    }
    
    func pdfThumbnail(url: URL?, width: CGFloat = 44) {
        DispatchQueue.main.async {
            guard let unUrl = url else { return }
            guard let data = try? Data(contentsOf: unUrl),
                  let page = PDFDocument(data: data)?.page(at: 0) else { return }
            let pageSize = page.bounds(for: .mediaBox)
            let pdfScale = width / pageSize.width
            // Apply if you're displaying the thumbnail on screen
            let scale = UIScreen.main.scale * pdfScale
            let screenSize = CGSize(width: pageSize.width * scale,
                                    height: pageSize.height * scale)
            self.fileImage = page.thumbnail(of: screenSize, for: .mediaBox)
        }
    }
    
    func getDateString() {
        DispatchQueue.main.async {
            let months: [String: String] = ["01": "янв", "02": "фев", "03": "марта", "04": "апр",
                                            "05": "мая", "06": "июня", "07": "июля", "08": "авг",
                                            "09": "сен", "10": "окт", "11": "нояб", "12": "дек"]
            let month = String(self.file.date.dayAndMonthAndYear.split(separator: ".")[1])
            guard let textMonth = months[month] else { return }
            self.date = String(self.file.date.dayAndMonthAndYear.split(separator: ".")[0] + " " + textMonth + " в " + self.file.date.hoursAndMinutes)
        }
    }
}
