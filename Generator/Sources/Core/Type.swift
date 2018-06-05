//
//  Type.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/06.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public protocol Type {
    var name: String { get }
    var generics: [Generic] { get }
    var conforms: [TypeName] { get }
}
