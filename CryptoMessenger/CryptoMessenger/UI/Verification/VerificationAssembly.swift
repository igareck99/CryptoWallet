import Foundation
import SwiftUI

enum VerificationAssembly {
    static func build(delegate: VerificationSceneDelegate?) -> some View {
        let viewModel = VerificationPresenter(delegate: delegate)
        let view = CodeVerificationView(viewModel: viewModel)
        return view
    }
}
