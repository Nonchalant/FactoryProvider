//
//  Providable.swift
//  FactoryProvider
//
//  Created by Takeshi Ihara on 2018/06/06.
//  Copyright © 2018年 Nonchalant. All rights reserved.
//

import Foundation

public protocol Providable {
    static func provide() -> Self
}

extension Array: Providable where Element: Providable {
    public static func provide() -> Array {
        return [Element.provide()]
    }
}

extension Bool: Providable {
    public static func provide() -> Bool {
        return false
    }
}

extension Character: Providable {
    public static func provide() -> Character {
        return Character(String.provide())
    }
}

extension Data: Providable {
    public static func provide() -> Data {
        return Data()
    }
}

extension Date: Providable {
    public static func provide() -> Date {
        return Date(timeIntervalSince1970: 0)
    }
}

extension Dictionary: Providable where Key: Providable, Value: Providable {
    public static func provide() -> Dictionary {
        return [Key.provide(): Value.provide()]
    }
}

extension Double: Providable {
    public static func provide() -> Double {
        return 0
    }
}

extension Float: Providable {
    public static func provide() -> Float {
        return 0
    }
}

extension Int: Providable {
    public static func provide() -> Int {
        return 0
    }
}

extension Int8: Providable {
    public static func provide() -> Int8 {
        return 0
    }
}

extension Int16: Providable {
    public static func provide() -> Int16 {
        return 0
    }
}

extension Int32: Providable {
    public static func provide() -> Int32 {
        return 0
    }
}

extension Int64: Providable {
    public static func provide() -> Int64 {
        return 0
    }
}

extension Optional: Providable where Wrapped: Providable {
    public static func provide() -> Optional {
        return .some(Wrapped.provide())
    }
}

extension String: Providable {
    public static func provide() -> String {
        return ""
    }
}

extension UInt: Providable {
    public static func provide() -> UInt {
        return 0
    }
}

extension UInt8: Providable {
    public static func provide() -> UInt8 {
        return 0
    }
}

extension UInt16: Providable {
    public static func provide() -> UInt16 {
        return 0
    }
}

extension UInt32: Providable {
    public static func provide() -> UInt32 {
        return 0
    }
}

extension UInt64: Providable {
    public static func provide() -> UInt64 {
        return 0
    }
}

extension URL: Providable {
    public static func provide() -> URL {
        return URL(string: "https://github.com/Nonchalant/FactoryProvider")!
    }
}
