public protocol Type {
    var name: String { get }
    var generics: [Generic] { get }
    var conforms: [TypeName] { get }
}
