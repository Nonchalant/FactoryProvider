import Foundation

public struct TypeName: Element, Equatable {
    public let name: String
    
    public init(name: String) {
        self.name = name.split(separator: "&").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
