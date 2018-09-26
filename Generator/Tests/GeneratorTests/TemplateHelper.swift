import Foundation

struct TemplateHelper {
    static func factory(enums: String? = nil, protocols: String? = nil, structs: String? = nil) -> String {
        return """
        // MARK: - Enum
        \(component(with: enums))
        // MARK: - Struct
        \(component(with: structs))
        
        """
    }
    
    static func lens(structs: String? = nil) -> String {
        return """
        // MARK: - Lens
        \(component(with: structs))
        
        """
    }
    
    private static func component(with types: String?, prefix: String = "\n", suffix: String = "\n") -> String {
        guard let types = types else {
            return ""
        }
        return "\(prefix)\(types)\(suffix)"
    }
}
