//
//  VariableParser.swift
//  Parser
//
//  Created by Ihara Takeshi on 2018/06/07.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import Foundation
import SourceKittenFramework

struct VariableParser: ElementParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File) -> Variable? {
        guard let kind = (structure[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init), kind == .varInstance else {
            return nil
        }

        guard let name = structure[SwiftDocKey.name.rawValue] as? String,
            let typeName = (structure[SwiftDocKey.typeName.rawValue] as? String).flatMap(TypeName.init) else {
            return nil
        }
        
        guard let offset = structure[SwiftDocKey.offset.rawValue] as? Int64,
            let length = structure[SwiftDocKey.length.rawValue] as? Int64 else {
                return nil
        }
        
        let contents = raw.contents
        let variable = String(contents[contents.index(contents.startIndex, offsetBy: Int(offset))..<contents.index(contents.startIndex, offsetBy: Int(offset + length))])
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // StoredProperty
        guard !variable.contains("=") || !variable.contains("let") else {
            return nil
        }
                
        // ComputedProperty
        if let regex = try? NSRegularExpression(pattern:  "\\{(.|\n)*\\}$"),
            let _ = regex.firstMatch(in: variable, range: NSRange(location: 0, length: variable.count)) {
            return nil
        }

        return Variable(name: name, typeName: typeName)
    }
}
