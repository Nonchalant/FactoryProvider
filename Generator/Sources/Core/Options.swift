//
//  Options.swift
//  Core
//
//  Created by Ihara Takeshi on 2018/06/10.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import PathKit
import Yaml

public struct Options {
    private let includes: [String]
    private let excludes: [String]
    
    public private(set) var inputs: [String] = []
    public let testables: [String]
    public let output: String
    
    public init?(raw: String) {
        guard let config = try? Yaml.load(raw) else {
            return nil
        }
        
        self.includes = config["includes"].array?.compactMap({ $0.string }) ?? []
        self.excludes = config["excludes"].array?.compactMap({ $0.string }) ?? []
        self.testables = config["testables"].array?.compactMap({ $0.string }) ?? []
        self.output = config["output"].string ?? "./Factories.generated.swift"
        
        self.inputs = Array(Set(includes.map(children).flatMap({ $0 })).subtracting(Set(excludes.map(children).flatMap({ $0 }))))
    }
    
    private func children(with path: String) -> [String] {
        let content = Path(path)
        
        guard content.isDirectory else {
            return [content.string]
        }
        
        guard let children = try? Path(path).recursiveChildren() else {
            return []
        }
        
        return children.map({ $0.string }).filter({ $0.hasSuffix(".swift") })
    }
}
