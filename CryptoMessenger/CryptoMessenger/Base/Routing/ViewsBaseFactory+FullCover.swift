import SwiftUI

extension ViewsBaseFactory {
    @ViewBuilder
    static func makeFullCover(link: BaseFullCoverLink) -> some View {
        switch link {
        case let .imageViewer(imageUrl):
            SimpleImageViewerAssembly.build(imageUrl: imageUrl)
        case let .video(url):
            VideoPlayViewAssembly.build(videoUrl: url)
        case let .openOtherApp(
            place,
            showLocationTransition
        ):
            AnotherAppTransitionViewAssembly.build(
                place: place,
                showLocationTransition: showLocationTransition
            )
        }
    }
}
