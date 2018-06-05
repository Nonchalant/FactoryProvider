//
//  EnumParser.swift
//  Parser
//
//  Created by Ihara Takeshi on 2018/06/08.
//

import Core
import SourceKittenFramework

struct EnumParser: TypeParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File, name: String, generics: [Generic], conforms: [TypeName]) -> Enum? {
        return Enum(
            name: name,
            generics: generics,
            conforms: conforms,
            cases: EnumCaseParser.parse(structure: structure, key: .substructure, raw: raw)
        )
    }
}
