import Foundation
import SwiftUI

// MARK: - PickerView

struct PickerView: UIViewRepresentable {
    @Binding var selectedIndex: Int
    private let data: [String]
    private let cellHeight = CGFloat(60)

    init(data: [String], selectedIndex: Binding<Int>) {
        self.data = data
        self._selectedIndex = selectedIndex
    }

    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        uiView.subviews.last?.backgroundColor = .clear
        uiView.selectRow(selectedIndex, inComponent: 0, animated: false)
        uiView.reloadAllComponents()
    }

    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

        private let picker: PickerView

        init(_ pickerView: PickerView) {
            self.picker = pickerView
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return picker.data.count
        }

        func pickerView(
            _ pickerView: UIPickerView,
            viewForRow row: Int,
            forComponent component: Int,
            reusing view: UIView?
        ) -> UIView {

            var pickerLabel: UILabel

            if let label = view as? UILabel {
                pickerLabel = label
            } else {
                pickerLabel = UILabel(
                    frame: CGRect(
                        x: 0,
                        y: 0,
                        width: pickerView.frame.size.width,
                        height: picker.cellHeight
                    )
                )
            }

            if pickerView.selectedRow(inComponent: component) == row {
                pickerLabel.font = .systemFont(ofSize: 22, weight: .bold)
                pickerLabel.backgroundColor = #colorLiteral(red: 0.8, green: 0.4823529412, blue: 0.8941176471, alpha: 1).withAlphaComponent(0.1)
                pickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                pickerLabel.font = .systemFont(ofSize: 20)
                pickerLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                pickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.4)
            }

            pickerLabel.textAlignment = .center
            pickerLabel.text = picker.data[row]
            return pickerLabel
        }

        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return picker.cellHeight
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

            picker.selectedIndex = row
            pickerView.reloadAllComponents()
        }
    }
}
