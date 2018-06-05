//
//  Arguments.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/07.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core

struct Arguments {
    let types: Types
    let testables: [String]

    var dictionary: [String: Any] {
        return [
            "types": types,
            "testables": testables
        ]
    }
}
