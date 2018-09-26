public struct Struct: Type {
    public let name: String
    public let generics: [Generic]
    public let conforms: [TypeName]
    public let variables: [Variable]

    public init(name: String, generics: [Generic], conforms: [TypeName], variables: [Variable]) {
        self.name = name
        self.generics = generics
        self.conforms = conforms
        self.variables = variables
    }
}
