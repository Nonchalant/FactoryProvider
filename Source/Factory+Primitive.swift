import Foundation

extension Factory {
    public static func provide<E>() -> Type where Type == Array<E> {
        return [Factory<E>.provide()]
    }
}

extension Factory where Type == Bool {
    public static func provide() -> Type {
        return false
    }
}

extension Factory where Type == Character {
    public static func provide() -> Type {
        return Character(Factory<String>.provide())
    }
}

extension Factory where Type == Data {
    public static func provide() -> Type {
        return Data()
    }
}

extension Factory where Type == Date {
    public static func provide() -> Type {
        return Date(timeIntervalSince1970: 0)
    }
}

extension Factory {
    public static func provide<K, V>() -> Type where Type == Dictionary<K, V> {
        return [Factory<K>.provide(): Factory<V>.provide()]
    }
}

extension Factory where Type == Double {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == Float {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == Int {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == Int8 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == Int16 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == Int32 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == Int64 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory {
    public static func provide<W>() -> Type where Type == Optional<W> {
        return .some(Factory<W>.provide())
    }
}

extension Factory where Type == String {
    public static func provide() -> Type {
        return ""
    }
}

extension Factory where Type == UInt {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == UInt8 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == UInt16 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == UInt32 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == UInt64 {
    public static func provide() -> Type {
        return 0
    }
}

extension Factory where Type == URL {
    public static func provide() -> Type {
        return URL(string: Factory<String>.provide())!
    }
}
