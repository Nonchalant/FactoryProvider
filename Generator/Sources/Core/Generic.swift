public struct Generic: Element {
    public let name: String
    public let conforms: [TypeName]
    
    public init(name: String, conforms: [TypeName]) {
        self.name = name
        self.conforms = conforms
    }
}
