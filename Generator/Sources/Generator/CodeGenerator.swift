//
//  CodeGenerator.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/10.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import StencilSwiftKit

struct CodeGenerator {
    static func run(types: [Type], by template: Template, with options: Options) throws -> String {
        let arguments = Arguments(types: Types(types: types), testables: options.testables)
        return try StencilSwiftTemplate(templateString: template.rawValue).render(arguments.dictionary)
    }
}
