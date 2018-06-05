//
//  FileGenerator.swift
//  Generator
//
//  Created by Ihara Takeshi on 2018/06/10.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import PathKit

struct FileGenerator {
    static func run(render: String, with options: Options) throws {
        try Path(options.output).write(render)
    }
}
