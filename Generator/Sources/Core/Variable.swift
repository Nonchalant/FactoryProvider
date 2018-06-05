//
//  Variable.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/06.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public struct Variable: Element {
    public let name: String
    public let typeName: TypeName

    public init(name: String, typeName: TypeName) {
        self.name = name
        self.typeName = typeName
    }
}
