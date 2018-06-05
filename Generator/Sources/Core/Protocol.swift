//
//  Protocol.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/09.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public struct Protocol: Type {
    public let name: String
    public let generics: [Generic]
    public let conforms: [TypeName]
    
    public init(name: String, generics: [Generic], conforms: [TypeName]) {
        self.name = name
        self.generics = generics
        self.conforms = conforms
    }
}
