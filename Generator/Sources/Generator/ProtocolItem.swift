//
//  ProtocolItem.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/15.
//

import Core

struct ProtocolItem {
    let name: String
    let compatible: String
    
    init(protocol p: Protocol, types: [Type]) {
        self.name = p.name
        self.compatible = types.filter({ $0.conforms.contains(where: { $0.name == p.name }) }).first?.name ?? ""
    }
}
