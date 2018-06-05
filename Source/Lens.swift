//
//  Lens.swift
//  FactoryProvider
//
//  Created by Ihara Takeshi on 2018/06/11.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Foundation

public struct Lens<A, B> {
    private let getter: (A) -> B
    private let setter: (A, B) -> A
    
    public init(getter: @escaping (A) -> B, setter: @escaping (A, B) -> A) {
        self.getter = getter
        self.setter = setter
    }
    
    public func get(_ from: A) -> B {
        return getter(from)
    }
    
    public func set(_ from: A, _ to: B) -> A {
        return setter(from, to)
    }
    
    public func modify(_ from: A, f: (B) -> B) -> A {
        return set(from, f(get(from)))
    }
    
    public func compose<C>(other: Lens<B, C>) -> Lens<A, C> {
        return Lens<A, C>(
            getter: { (a: A) -> C in
                other.get(self.get(a))
            },
            setter: { (a: A, c: C) -> A in
                self.set(a, other.set(self.get(a), c))
            }
        )
    }
}
