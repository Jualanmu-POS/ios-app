//
//  FirebaseBlueprint.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 14/11/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Foundation
protocol FirebaseBlueprint {
    func key() -> Key
    func data() -> [String : Any]
    func childs(key: String) -> [String]
}
