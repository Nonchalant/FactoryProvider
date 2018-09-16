//
//  Factory.swift
//  FactoryProvider
//
//  Created by Ihara Takeshi on 2018/09/16.
//  Copyright © 2018 Nonchalant. All rights reserved.
//

import Foundation

public struct Factory<T: Providable> {
    public static func provide() -> T {
        return T.provide()
    }
}
