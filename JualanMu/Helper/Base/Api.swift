//
//  Api.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 26/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Alamofire

typealias OnSuccess = (([String:Any])->Void)?
typealias OnFailed = ((Error)->Void)?

enum Module: String {
    case loginAnonymously = "/loginguest"
    
}

protocol Api {
    var parameters: Parameters? { get }
    var httpMethod: HTTPMethod! { get }
    var headers: HTTPHeaders? { get }
    var module: Module! { get }
}
