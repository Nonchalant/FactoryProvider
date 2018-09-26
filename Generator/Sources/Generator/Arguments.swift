import Core

struct Arguments {
    let types: Types
    let testables: [String]

    var dictionary: [String: Any] {
        return [
            "types": types,
            "testables": testables
        ]
    }
}
