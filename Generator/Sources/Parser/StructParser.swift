//
//  StructParser.swift
//  Parser
//
//  Created by Ihara Takeshi on 2018/06/08.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

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
