import Foundation

extension Factory {
    public static func provide<E>() -> T where T == Array<E> {
        return [Factory<E>.provide()]
    }
}

extension Factory where T == Bool {
    public static func provide() -> T {
        return false
    }
}

extension Factory where T == Character {
    public static func provide() -> T {
        return Character(Factory<String>.provide())
    }
}

extension Factory where T == Data {
    public static func provide() -> T {
        return Data()
    }
}

extension Factory where T == Date {
    public static func provide() -> T {
        return Date(timeIntervalSince1970: 0)
    }
}

extension Factory {
    public static func provide<K, V>() -> T where T == Dictionary<K, V> {
        return [Factory<K>.provide(): Factory<V>.provide()]
    }
}

extension Factory where T == Double {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == Float {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == Int {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == Int8 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == Int16 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == Int32 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == Int64 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory {
    public static func provide<W>() -> T where T == Optional<W> {
        return .some(Factory<W>.provide())
    }
}

extension Factory where T == String {
    public static func provide() -> T {
        return ""
    }
}

extension Factory where T == UInt {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == UInt8 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == UInt16 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == UInt32 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == UInt64 {
    public static func provide() -> T {
        return 0
    }
}

extension Factory where T == URL {
    public static func provide() -> T {
        return URL(string: Factory<String>.provide())!
    }
}
