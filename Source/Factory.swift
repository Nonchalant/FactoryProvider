public struct Factory<T> {
    static func provide() -> T {
        fatalError()
    }
}
