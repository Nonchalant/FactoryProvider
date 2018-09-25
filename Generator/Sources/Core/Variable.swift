public struct Variable: Element {
    public let name: String
    public let typeName: TypeName

    public init(name: String, typeName: TypeName) {
        self.name = name
        self.typeName = typeName
    }
}
