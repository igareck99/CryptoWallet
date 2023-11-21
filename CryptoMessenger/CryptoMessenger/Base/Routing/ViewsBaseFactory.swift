import SwiftUI

protocol ViewsBaseFactoryProtocol {

    associatedtype Content: View

    @ViewBuilder
    static func makeContent(link: BaseContentLink) -> Content

    associatedtype Sheet: View

    @ViewBuilder
    static func makeSheet(link: BaseSheetLink) -> Sheet

    associatedtype FullCover: View

    @ViewBuilder
    static func makeFullCover(link: BaseFullCoverLink) -> FullCover
}

enum ViewsBaseFactory: ViewsBaseFactoryProtocol {}
