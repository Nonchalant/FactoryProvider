//
//  Types.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/09.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core

struct Types {
    let enums: [Enum]
    let structs: [Struct]
    
    init(types: [Type]) {
        self.enums = types.compactMap { $0 as? Enum }
        self.structs = types.compactMap { $0 as? Struct }
    }
}
