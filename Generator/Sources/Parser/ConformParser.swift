import Core
import SourceKittenFramework

struct ConformParser: ElementParser {
    static func parse(structure: [String : SourceKitRepresentable], raw: File) -> TypeName? {
        return (structure[SwiftDocKey.name.rawValue] as? String).flatMap(TypeName.init)
    }
}
