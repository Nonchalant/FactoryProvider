//
//  Generic.swift
//  Core
//
//  Created by Takeshi Ihara on 2018/06/11.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public struct Generic: Element {
    public let name: String
    public let conforms: [TypeName]
    
    public init(name: String, conforms: [TypeName]) {
        self.name = name
        self.conforms = conforms
    }
}
