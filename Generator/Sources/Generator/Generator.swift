//
//  Generator.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/07.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import PathKit
import StencilSwiftKit

public struct Generator {
    private let types: [Type]
    
    public init(types: [Type]) {
        self.types = types
    }
    
    public func run(with options: Options) throws {
        do {
            let render = try Template.allCases
                .map {
                    try CodeGenerator.run(types: types, by: $0, with: options)
                }
                .reduce("") { "\($0)\($1)" }
            try FileGenerator.run(render: render, with: options)
        } catch {
            throw GenerateError.render
        }
    }
}
