//
//  File.swift
//  
//
//  Created by 王小涛 on 2024/7/18.
//

import Foundation
import MobileCore

extension Member.State: TypeSafeIdentifiable, Identifiable {
    public typealias RawIdentifier = String
    
    public var id: ID<Self> {
        ID(rawValue: productID)
    }
}
