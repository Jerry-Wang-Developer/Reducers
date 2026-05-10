//
//  File.swift
//  
//
//  Created by 王小涛 on 2023/6/16.
//

import Foundation

extension JSONEncoder: AnyEncodableSerializer {
    public func serialize<Input>(_ input: Input) throws -> Data where Input: Encodable {
        try encode(input)
    }
}


