//
//  ConformParser.swift
//  Parser
//
//  Created by Takeshi Ihara on 2018/06/11.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import SourceKittenFramework

struct ConformParser: ElementParser {
    static func parse(structure: [String : SourceKitRepresentable], raw: File) -> TypeName? {
        return (structure[SwiftDocKey.name.rawValue] as? String).flatMap(TypeName.init)
    }
}
