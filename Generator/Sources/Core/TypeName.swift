//
//  TypeName.swift
//  Core
//
//  Created by Takeshi Ihara on 2018/06/11.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Foundation

public struct TypeName: Element {
    public let name: String
    
    public init(name: String) {
        self.name = name.split(separator: "&").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
