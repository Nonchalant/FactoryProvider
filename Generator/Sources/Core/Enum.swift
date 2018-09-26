public struct Enum: Type {
    public let name: String
    public let generics: [Generic]
    public let conforms: [TypeName]
    public let cases: [Case]

    public init(name: String, generics: [Generic], conforms: [TypeName], cases: [Case]) {
        self.name = name
        self.generics = generics
        self.conforms = conforms
        self.cases = cases
    }
}
