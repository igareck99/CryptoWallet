import MatrixSDK

extension MXEvent {
    public var timestamp: Date {
        Date(timeIntervalSince1970: TimeInterval(originServerTs / 1000))
    }

    public func content<T>(valueFor key: String) -> T? {
        content?[key] as? T
    }

    public func prevContent<T>(valueFor key: String) -> T? {
        unsignedData?.prevContent?[key] as? T
    }
}
