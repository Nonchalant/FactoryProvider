//
//  Options.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/10.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

public struct Options {
    public let inputs: [String]
    public let testables: [String]
    public let output: String
    
    public init(includes: [String], excludes: [String], testables: [String], output: String) {
        self.inputs = Array(Set(includes).subtracting(Set(excludes)))
        self.testables = Array(Set(testables))
        self.output = output
    }
}
