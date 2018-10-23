infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

public struct LensOver<Whole, Part> {
    private let getter: (Whole) -> Part
    private let setter: (Part, Whole) -> Whole

    public init(getter: @escaping (Whole) -> Part, setter: @escaping (Part, Whole) -> Whole) {
        self.getter = getter
        self.setter = setter
    }

    public func get(_ from: Whole) -> Part {
        return getter(from)
    }

    public func set(_ from: Part, _ to: Whole) -> Whole {
        return setter(from, to)
    }
}

public func * <A, B, C> (lhs: LensOver<A, B>, rhs: LensOver<B, C>) -> LensOver<A, C> {
    return LensOver<A, C>(
        getter: { a in
            rhs.get(lhs.get(a))
        },
        setter: { (c, a) in
            lhs.set(rhs.set(c, lhs.get(a)), a)
        }
    )
}

public func *~ <A, B> (lhs: LensOver<A, B>, rhs: B) -> (A) -> A {
    return { a in
        lhs.set(rhs, a)
    }
}

public func |> <A, B> (x: A, f: (A) -> B) -> B {
    return f(x)
}

public func |> <A, B, C> (f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { g(f($0)) }
}
