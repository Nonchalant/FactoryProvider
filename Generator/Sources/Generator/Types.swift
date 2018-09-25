import Core

struct Types {
    let enums: [Enum]
    let structs: [Struct]
    
    init(types: [Type]) {
        self.enums = types.compactMap { $0 as? Enum }
        self.structs = types.compactMap { $0 as? Struct }
    }
}
