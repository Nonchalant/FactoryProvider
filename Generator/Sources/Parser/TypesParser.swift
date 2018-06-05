//
//  TypesParser.swift
//  Parser
//
//  Created by Ihara Takeshi on 2018/06/07.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import SourceKittenFramework

struct TypesParser {
    private let file: File
    
    init(file: File) {
        self.file = file
    }
    
    func run() throws -> [Type] {
        do {
            let structure = try Structure(file: file).dictionary
            return parse(structure: structure)
        } catch {
            throw ParseError.parse
        }
    }

    private func parse(structure: [String: SourceKitRepresentable], parentName: String? = nil) -> [Type] {
        let types = [parse(structure: structure, parentName: parentName)].compactMap({ $0 })

        guard let substructure = structure[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] else {
            return types
        }

        return substructure
            .compactMap { $0 as? [String: SourceKitRepresentable] }
            .map { parse(structure: $0, parentName: parseParentName(structure: structure, parentName: parentName)) }
            .reduce(types) { $0 + $1 }
    }

    private func parse(structure: [String: SourceKitRepresentable], parentName: String?) -> Type? {
        guard let kind = (structure[SwiftDocKey.kind.rawValue] as? String).flatMap(SwiftDeclarationKind.init) else {
            return nil
        }

        switch kind {
        case .enum:
            return EnumParser.parse(structure: structure, raw: file, parentName: parentName)
        case .protocol:
            return ProtocolParser.parse(structure: structure, raw: file, parentName: parentName)
        case .struct:
            return StructParser.parse(structure: structure, raw: file, parentName: parentName)
        default:
            return nil
        }
    }
    
    private func parseParentName(structure: [String: SourceKitRepresentable], parentName: String?) -> String? {
        guard let name = structure[SwiftDocKey.name.rawValue] as? String, structure[SwiftDocKey.kind.rawValue] != nil else {
            return nil
        }
        
        return parentName.map({ "\($0).\(name)" }) ?? name
    }
}
