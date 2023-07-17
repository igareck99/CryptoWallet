import SwiftUI

enum TransactionResultAssembly {
    static func build(model: TransactionResult) -> some View {
        TransactionResultView(model: model, height: 302)
    }
}
