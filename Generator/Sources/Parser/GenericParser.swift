import Core
import Foundation
import SourceKittenFramework

struct GenericParser {
    static func parse(structure: [String : SourceKitRepresentable], raw: File) -> [Generic] {
        guard let nameOffset = structure[SwiftDocKey.nameOffset.rawValue] as? Int64,
            let bodyOffset = structure[SwiftDocKey.bodyOffset.rawValue] as? Int64 else {
                return []
        }
        
        let contents = raw.contents
        let name = String(contents[contents.index(contents.startIndex, offsetBy: Int(nameOffset))..<contents.index(contents.startIndex, offsetBy: Int(bodyOffset - 1))])
        
        guard let regex = try? NSRegularExpression(pattern:  "<.*>"),
            let match = regex.firstMatch(in: name, range: NSRange(location: 0, length: name.count)),
            let range = Range(match.range, in: name) else {
                return []
        }
        
        let generics = String(name[range])
        
        return String(generics[generics.index(after: generics.startIndex)..<generics.index(before: generics.endIndex)])
            .split(separator: ",")
            .map { parse(raw: String($0)) }
            .compactMap { $0 }
    }
    
    private static func parse(raw: String) -> Generic? {
        let raws = raw.split(separator: ":")
        guard let name = raws.first.map(String.init)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        
        let conforms = raws.dropFirst().first?
            .split(separator: "&")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map(TypeName.init) ?? []
        
        return Generic(name: name, conforms: conforms)
    }
}
