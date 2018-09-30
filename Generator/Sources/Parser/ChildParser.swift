import Core
import SourceKittenFramework

struct ChildParser: ElementParser {
    static func parse(structure: [String : SourceKitRepresentable], raw: File) -> TypeName? {
        guard let kind = (structure[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init),
            [.class, .enum, .struct].contains(kind) else {
            return nil
        }
        
        return (structure[SwiftDocKey.name.rawValue] as? String).map(TypeName.init)
    }
    
    static func parse(structure: [String: SourceKitRepresentable], key: SwiftDocKey, raw: File) -> [TypeName] {
        guard let name = structure[SwiftDocKey.name.rawValue] as? String,
            let substructures = structure[key.rawValue] as? [SourceKitRepresentable] else {
            return []
        }
        
        let innerTypes = substructures
            .compactMap { $0 as? [String: SourceKitRepresentable] }
            .map { parse(structure: $0, raw: raw) }
            .compactMap { $0 }
                
        guard let structures = (try? Structure(file: raw))?.dictionary[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] else {
            return innerTypes
        }
        
        let extensionInnerTypes = structures
            .compactMap { $0 as? [String: SourceKitRepresentable] }
            .filter { ($0[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init) == .extension }
            .filter { ($0[SwiftDocKey.name.rawValue] as? String) == name }
            .map { $0[key.rawValue] as? [SourceKitRepresentable] }
            .compactMap {
                $0?
                    .compactMap { $0 as? [String: SourceKitRepresentable] }
                    .map { parse(structure: $0, raw: raw) }
                    .compactMap { $0 }
            }
            .flatMap { $0 }
        
        return innerTypes + extensionInnerTypes
    }
}
