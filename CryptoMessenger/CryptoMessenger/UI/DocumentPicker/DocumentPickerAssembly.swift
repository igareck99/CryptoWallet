import Foundation
import SwiftUI

enum DocumentPickerAssembly {
    static func build(
        onCancel: VoidBlock?,
        onDocumentsPicked: @escaping GenericBlock<[URL]>
    ) -> some View {
        DocumentPicker(
            onCancel: onCancel,
            onDocumentsPicked: onDocumentsPicked
        )
    }
}
