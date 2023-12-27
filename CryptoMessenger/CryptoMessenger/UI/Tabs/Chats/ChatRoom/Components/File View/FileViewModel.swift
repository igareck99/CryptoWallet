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

    init(
        url: URL?,
        file: FileData = .makeEmptyFile()
    ) {
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
                DispatchQueue.main.async {
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
    }

    func pdfThumbnail(url: URL?, width: CGFloat = 44) {
        guard let fileUrl = url else { return }
        Task {
            let result = await remoteDataService.downloadRequest(url: fileUrl)
            guard let data = result?.0, let page = PDFDocument(data: data)?.page(at: 0) else {
                return
            }
            let pageSize = page.bounds(for: .mediaBox)
            let pdfScale = width / pageSize.width
            let scale = await UIScreen.main.scale * pdfScale
            let screenSize = CGSize(
                width: pageSize.width * scale,
                height: pageSize.height * scale
            )
            let docImage = page.thumbnail(of: screenSize, for: .mediaBox)
            await MainActor.run {
                self.fileImage = docImage
            }
        }
    }

    func getDateString() {
        let months: [String: String] = [
            "01": "янв", "02": "фев", "03": "марта", "04": "апр",
            "05": "мая", "06": "июня", "07": "июля", "08": "авг",
            "09": "сен", "10": "окт", "11": "нояб", "12": "дек"
        ]
        let month = String(self.file.date.dayAndMonthAndYear.split(separator: ".")[1])
        guard let textMonth = months[month] else { return }
        let dateStr = String(self.file.date.dayAndMonthAndYear.split(separator: ".")[0] + " " + textMonth + " в " + self.file.date.hoursAndMinutes)
        DispatchQueue.main.async {
            self.date = dateStr
        }
    }
}
