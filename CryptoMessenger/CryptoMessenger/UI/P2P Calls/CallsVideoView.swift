import SwiftUI
import UIKit

struct CallsVideoView: UIViewRepresentable {

    weak var view: UIView?

    func makeUIView(context: Context) -> UIView {
        view ?? UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
