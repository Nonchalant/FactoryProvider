//
//  TemplateHelper.swift
//  GeneratorTests
//
//  Created by Ihara Takeshi on 2018/06/12.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Foundation

struct TemplateHelper {
    static func factory(enums: String? = nil, protocols: String? = nil, structs: String? = nil) -> String {
        return """
        // MARK: - Factory
        
        struct Factory<T>: Providable {
            static func provide() -> T {
                switch T.self {
                case is Providable.Type:
                    return (T.self as! Providable.Type).provide() as! T\(component(with: protocols, suffix: ""))
                default:
                    fatalError()
                }
            }
        }
        
        // MARK: - Enum
        \(component(with: enums))
        // MARK: - Struct
        \(component(with: structs))
        
        """
    }
    
    static func lens(structs: String? = nil) -> String {
        return """
        // MARK: - Lens
        \(component(with: structs))
        
        """
    }
    
    private static func component(with types: String?, prefix: String = "\n", suffix: String = "\n") -> String {
        guard let types = types else {
            return ""
        }
        return "\(prefix)\(types)\(suffix)"
    }
}
