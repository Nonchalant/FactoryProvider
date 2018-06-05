//
//  ProtocolParser.swift
//  Parser
//
//  Created by Ihara Takeshi on 2018/06/09.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import SourceKittenFramework

struct ProtocolParser: TypeParser {
    static func parse(structure: [String: SourceKitRepresentable], raw: File, name: String, generics: [Generic], conforms: [TypeName]) -> Protocol? {
        return Protocol(name: name, generics: generics, conforms: conforms)
    }
}
