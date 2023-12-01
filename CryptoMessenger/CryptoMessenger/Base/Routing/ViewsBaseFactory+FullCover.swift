import SwiftUI

extension ViewsBaseFactory {
    @ViewBuilder
    static func makeFullCover(link: BaseFullCoverLink) -> some View {
        switch link {
        case let .imageViewer(image, url):
            SimpleImageViewerAssembly.build(image: image, url: url)
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
