import Core
import SourceKittenFramework

struct StructParser: TypeParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File, name: String, generics: [Generic], conforms: [TypeName]) -> Struct? {
        return Struct(
            name: name,
            generics: generics,
            conforms: conforms,
            variables: VariableParser.parse(structure: structure, key: .substructure, raw: raw)
        )
    }
}
