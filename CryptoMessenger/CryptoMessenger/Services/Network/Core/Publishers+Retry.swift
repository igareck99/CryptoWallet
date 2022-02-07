import Combine

// MARK: - Publisher ()

extension Publisher {

    // MARK: - Internal Methods

    func retry(_ times: Int, if condition: @escaping (Failure) -> Bool) -> Publishers.ConditionalRetry<Self> {
        Publishers.ConditionalRetry(publisher: self, times: times, condition: condition)
    }
}

// MARK: - Publishers ()

extension Publishers {

    // MARK: - ConditionalRetry

    struct ConditionalRetry<P: Publisher>: Publisher {

        // MARK: - Type

        typealias Output = P.Output
        typealias Failure = P.Failure

        // MARK: - Internal Properties

        let publisher: P
        let times: Int
        let condition: (P.Failure) -> Bool

        // MARK: - Internal Methods

        func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
            guard times > 0 else { return publisher.receive(subscriber: subscriber) }

            publisher
                .catch { (error: P.Failure) -> AnyPublisher<Output, Failure> in
                    if condition(error) {
                        return ConditionalRetry(publisher: publisher, times: times - 1, condition: condition)
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: error)
                            .eraseToAnyPublisher()
                    }
                }
                .receive(subscriber: subscriber)
        }
    }
}
