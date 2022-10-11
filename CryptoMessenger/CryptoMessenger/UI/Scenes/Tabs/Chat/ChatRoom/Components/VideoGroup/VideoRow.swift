import SwiftUI
import AVFoundation

struct VideoRow: View {

    let video: Video
    @State private var thumbnailImage = Image("")

    private let imageHeight: CGFloat = 250
    private let imageCornerRadius: CGFloat = 12.0

    var body: some View {
        VStack(alignment: .leading) {
            thumbnailImage
                .resizable()
                .scaledToFill()
                .frame(width: 202, height: 245)
                .background(.darkBlack())
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: imageCornerRadius,
                        style: .continuous))
                .shadow(radius: imageCornerRadius / 3.0)
        }
        .padding(.vertical)
        .onAppear {
            self.getThumbnailImageFromVideoUrl() { thumbImage in
                guard let image = thumbImage else { return }
                self.thumbnailImage = image
            }
        }
    }

    private func getThumbnailImageFromVideoUrl(completion: @escaping ((_ image: Image?) -> Void)) {
        DispatchQueue.global().async {
            guard let url = video.videoURL else {
                completion(nil)
                return
            }
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = Image(uiImage: UIImage(cgImage: cgThumbImage))
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
