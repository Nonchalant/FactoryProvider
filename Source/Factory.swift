public struct Factory<Type> {
    static func provide() -> Type {
        fatalError()
    }
}
