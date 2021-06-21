import Combine

// MARK: ObservableArray

final class ObservableArray<T>: ObservableObject {
    @Published var array: [T]

    init(array: [T]) {
        self.array = array
    }
}
