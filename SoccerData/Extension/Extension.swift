//
//  Extension.swift
//  SoccerData
//
//  Created by Alfian Losari on 06/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

extension Int: Identifiable {
    public var id: Int { self }
}

public extension String {
    func paddedToWidth(_ width: Int) -> String {
        let length = self.count
        guard length < width else {
            return self
        }
        
        let spaces = Array<String>.init(repeating: " ", count: width - length)
        let result = self + spaces.reduce("", +)
        return result
    }
}
