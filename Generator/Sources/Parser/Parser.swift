//
//  Parser.swift
//  Parser
//
//  Created by Ihara Takeshi on 2018/06/06.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Core
import SourceKittenFramework

public struct Parser {
    private let paths: [String]

    public init(paths: [String]) {
        self.paths = paths
    }

    public func run() throws -> [Type] {
        return try paths
            .map { path -> File in
                guard let file = File(path: path) else {
                    throw ParseError.fileOpen
                }
                return file
            }
            .map { try TypesParser(file: $0).run() }
            .reduce([]) { $0 + $1 }
    }
}
