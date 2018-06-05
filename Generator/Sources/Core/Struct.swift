//
//  Struct.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/06.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public struct Struct: Type {
    public let name: String
    public let generics: [Generic]
    public let conforms: [TypeName]
    public let variables: [Variable]

    public init(name: String, generics: [Generic], conforms: [TypeName], variables: [Variable]) {
        self.name = name
        self.generics = generics
        self.conforms = conforms
        self.variables = variables
    }
}
