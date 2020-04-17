//
//  BaseUrlFirebase.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 02/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import UIKit

class BaseUrlFirebase: FirebaseBlueprint {
    
    init() {
        
    }
    
    func key() -> Key {
        return .base_url
    }
    
    func data() -> [String : Any] {
        return [:]
    }
    
    func childs(key: String) -> [String] {
        return []
    }
    

}
