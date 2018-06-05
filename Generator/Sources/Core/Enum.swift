//
//  Enum.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/08.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public struct Enum: Type {
    public let name: String
    public let generics: [Generic]
    public let conforms: [TypeName]
    public let cases: [Case]

    public init(name: String, generics: [Generic], conforms: [TypeName], cases: [Case]) {
        self.name = name
        self.generics = generics
        self.conforms = conforms
        self.cases = cases
    }
}
