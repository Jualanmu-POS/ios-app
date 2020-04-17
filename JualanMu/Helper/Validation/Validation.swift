//
//  Validation.swift
//  Storial
//
//  Created by Azmi Muhammad on 28/10/19.
//  Copyright © 2019 Clapping Ape. All rights reserved.
//

import Foundation
protocol Validation {
    func check(s: String, regex: Regex) -> Bool
    func isDateValid(s: String) -> Bool
    func isEmpty(s: String) -> Bool
}
