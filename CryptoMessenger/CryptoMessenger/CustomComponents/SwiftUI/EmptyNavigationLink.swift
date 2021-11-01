import SwiftUI

// MARK: - EmptyNavigationLink

struct EmptyNavigationLink<Destination>: View where Destination: View {

    // MARK: - Internal Properties

    let destination: Destination
    let isActive: Binding<Bool>

    // MARK: - Lifecycle

    init(destination: Destination, isActive: Binding<Bool>) {
        self.destination = destination
        self.isActive = isActive
    }

    init<T>(destination: Destination, selectedItem: Binding<T?>) {
        self.destination = destination
        self.isActive = selectedItem.map(valueToMappedValue: { $0 != nil }, mappedValueToValue: { _ in nil })
    }

    // MARK: - Body

    var body: some View {
        NavigationLink(
            destination: destination,
            isActive: isActive,
            label: { EmptyView() }
        )
            .isDetailLink(false)
            .buttonStyle(.plain)
    }
}

// MARK: - Binding ()

extension Binding {

    // MARK: - Internal Methods

    func map<MappedValue>(
        valueToMappedValue: @escaping (Value) -> MappedValue,
        mappedValueToValue: @escaping (MappedValue) -> Value
    ) -> Binding<MappedValue> {
        Binding<MappedValue> { () -> MappedValue in
            valueToMappedValue(wrappedValue)
        } set: { mappedValue in
            wrappedValue = mappedValueToValue(mappedValue)
        }
    }

    func onSet(_ action: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding { () -> Value in
            wrappedValue
        } set: { value in
            action(value)
            wrappedValue = value
        }
    }
}
