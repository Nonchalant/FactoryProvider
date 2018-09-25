extension Enum {
    public struct Case: Element {
        public let name: String
        public let variables: [Variable]

        public init(name: String, variables: [Variable]) {
            self.name = name
            self.variables = variables
        }
    }
}
