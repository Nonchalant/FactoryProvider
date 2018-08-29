//
//  TypesItem.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/09.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core

struct TypesItem {
    let protocols: [ProtocolItem]
    let enums: [Enum]
    let structs: [Struct]
    
    init(types: [Type]) {
        self.protocols = types.compactMap({ $0 as? Protocol }).map({ ProtocolItem(protocol: $0, types: types) })
        self.enums = types.compactMap { $0 as? Enum }
        self.structs = types.compactMap { $0 as? Struct }
    }
}
