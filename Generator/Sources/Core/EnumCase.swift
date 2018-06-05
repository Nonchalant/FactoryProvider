//
//  EnumCase.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/08.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

extension Enum {
    public struct Case: Element {
        let name: String
        let variables: [Variable]

        public init(name: String, variables: [Variable]) {
            self.name = name
            self.variables = variables
        }
    }
}
