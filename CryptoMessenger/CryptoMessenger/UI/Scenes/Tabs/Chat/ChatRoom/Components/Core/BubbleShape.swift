import SwiftUI

// MARK: - BubbleShape

struct BubbleShape: Shape {

    // MARK: - Direction

    enum Direction {

        // MARK: - Types

        case left, right
    }

    // MARK: - Internal Properties

    let direction: Direction

    // MARK: - Internal Methods

    func path(in rect: CGRect) -> Path {
        direction == .left ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)
    }

    // MARK: - Private Methods

    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 20, y: height))
            p.addLine(to: CGPoint(x: width - 15, y: height))
            p.addCurve(
                to: CGPoint(x: width, y: height - 15),
                control1: CGPoint(x: width - 8, y: height),
                control2: CGPoint(x: width, y: height - 8)
            )
            p.addLine(to: CGPoint(x: width, y: 15))
            p.addCurve(
                to: CGPoint(x: width - 15, y: 0),
                control1: CGPoint(x: width, y: 8),
                control2: CGPoint(x: width - 8, y: 0)
            )
            p.addLine(to: CGPoint(x: 20, y: 0))
            p.addCurve(to: CGPoint(x: 5, y: 15), control1: CGPoint(x: 12, y: 0), control2: CGPoint(x: 5, y: 8))
            p.addLine(to: CGPoint(x: 5, y: height - 10))
            p.addCurve(
                to: CGPoint(x: 0, y: height),
                control1: CGPoint(x: 5, y: height - 1),
                control2: CGPoint(x: 0, y: height)
            )
            p.addLine(to: CGPoint(x: -1, y: height))
            p.addCurve(
                to: CGPoint(x: 12, y: height - 4),
                control1: CGPoint(x: 4, y: height + 1),
                control2: CGPoint(x: 8, y: height - 1)
            )
            p.addCurve(
                to: CGPoint(x: 20, y: height),
                control1: CGPoint(x: 15, y: height),
                control2: CGPoint(x: 20, y: height)
            )
        }
        return path
    }

    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: width - 20, y: height))
            p.addLine(to: CGPoint(x: 15, y: height))
            p.addCurve(
                to: CGPoint(x: 0, y: height - 15),
                control1: CGPoint(x: 8, y: height), control2: CGPoint(x: 0, y: height - 8)
            )
            p.addLine(to: CGPoint(x: 0, y: 15))
            p.addCurve(to: CGPoint(x: 15, y: 0), control1: CGPoint(x: 0, y: 8), control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 20, y: 0))
            p.addCurve(
                to: CGPoint(x: width - 5, y: 15),
                control1: CGPoint(x: width - 12, y: 0),
                control2: CGPoint(x: width - 5, y: 8)
            )
            p.addLine(to: CGPoint(x: width - 5, y: height - 12))
            p.addCurve(
                to: CGPoint(x: width, y: height),
                control1: CGPoint(x: width - 5, y: height - 1),
                control2: CGPoint(x: width, y: height)
            )
            p.addLine(to: CGPoint(x: width + 1, y: height))
            p.addCurve(
                to: CGPoint(x: width - 12, y: height - 4),
                control1: CGPoint(x: width - 4, y: height + 1),
                control2: CGPoint(x: width - 8, y: height - 1)
            )
            p.addCurve(
                to: CGPoint(x: width - 20, y: height),
                control1: CGPoint(x: width - 15, y: height),
                control2: CGPoint(x: width - 20, y: height)
            )
        }
        return path
    }
}
