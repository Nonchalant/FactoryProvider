import Core
import SourceKittenFramework

struct StructParser: TypeParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File, name: String, generics: [Generic], conforms: [TypeName]) -> Struct? {
        let children = ChildParser.parse(structure: structure, key: .substructure, raw: raw)
        let variables = VariableParser.parse(structure: structure, key: .substructure, raw: raw)
            .map {
                children.contains($0.typeName) ? $0.setParent(with: name) : $0
            }
        
        return Struct(
            name: name,
            generics: generics,
            conforms: conforms,
            variables: variables
        )
    }
}
