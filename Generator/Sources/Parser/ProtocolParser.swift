import Core
import SourceKittenFramework

struct ProtocolParser: TypeParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File, name: String, generics: [Generic], conforms: [TypeName]) -> Protocol? {
        return Protocol(name: name, generics: generics, conforms: conforms)
    }
}
