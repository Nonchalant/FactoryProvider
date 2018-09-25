import Core
import Foundation
import SourceKittenFramework

struct EnumCaseParser: ElementParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File) -> Enum.Case? {
        guard (structure[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init) == .enumcase else {
            return nil
        }

        guard let substructure = (structure[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable])?.first as? [String: SourceKitRepresentable] else {
            return nil
        }

        guard let name = substructure[SwiftDocKey.name.rawValue] as? String,
            (substructure[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init) == .enumelement else {
            return nil
        }
                
        guard let offset = structure[SwiftDocKey.offset.rawValue] as? Int64,
            let length = structure[SwiftDocKey.length.rawValue] as? Int64 else {
                return nil
        }
        
        let contents = raw.contents
        let enumCase = String(contents[contents.index(contents.startIndex, offsetBy: Int(offset))..<contents.index(contents.startIndex, offsetBy: Int(offset + length))])
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        var variables: [Variable] = []
        if let regex = try? NSRegularExpression(pattern:  "\\((.|\n)*\\)$"),
            let match = regex.firstMatch(in: enumCase, range: NSRange(location: 0, length: enumCase.count)),
            let range = Range(match.range, in: enumCase) {
            
            let associatedValues = String(enumCase[range])
            
            variables = String(associatedValues[associatedValues.index(after: associatedValues.startIndex)..<associatedValues.index(before: associatedValues.endIndex)])
                .split(separator: ",")
                .map { parse(raw: String($0)) }
                .compactMap { $0 }
        }

        return Enum.Case(name: name, variables: variables)
    }
    
    private static func parse(raw: String) -> Variable? {
        let raws = raw.split(separator: ":")
        switch raws.count {
        case 2:
            guard let name = raws.first.map(String.init)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return nil
            }
            
            guard let typeName = raws.dropFirst().first.map(String.init)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return nil
            }
            
            return Variable(name: name, typeName: TypeName(name: typeName))
        case 1:
            guard let typeName = raws.first.map(String.init)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return nil
            }
            
            return Variable(name: "", typeName: TypeName(name: typeName))
        default:
            return nil
        }
    }
}
