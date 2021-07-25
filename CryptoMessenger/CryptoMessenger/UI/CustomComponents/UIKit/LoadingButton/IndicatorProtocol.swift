import UIKit

protocol IndicatorProtocol {
    var radius: CGFloat { get set }
    var color: Palette { get set }
    var isAnimating: Bool { get }

    func startAnimating()
    func stopAnimating()
}
