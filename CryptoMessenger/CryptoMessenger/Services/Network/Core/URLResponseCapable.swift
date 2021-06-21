import Foundation

// MARK: - URLResponseCapable

protocol URLResponseCapable {
    associatedtype ResponseType

    func handle(data: Data) throws -> ResponseType
}
