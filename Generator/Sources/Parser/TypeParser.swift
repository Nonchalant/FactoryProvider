import Core
import SourceKittenFramework

protocol TypeParser {
    associatedtype T: Type
    static func parse(structure: [String: SourceKitRepresentable], raw: File, name: String, generics: [Generic], conforms: [TypeName]) -> T?
    static func parse(structure: [String: SourceKitRepresentable], raw: File, parentName: String?) -> T?
}

extension TypeParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File, parentName: String?) -> T? {
        guard let name = structure[SwiftDocKey.name.rawValue] as? String else {
            return nil
        }
        
        return parse(structure: structure,
                     raw: raw,
                     name: parentName.map({ "\($0).\(name)" }) ?? name,
                     generics: GenericParser.parse(structure: structure, raw: raw),
                     conforms: ConformParser.parse(structure: structure, key: .inheritedtypes, raw: raw))
    }
}
