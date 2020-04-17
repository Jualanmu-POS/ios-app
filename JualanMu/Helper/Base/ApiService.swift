//
//  BaseApi.swift
//  JualanMu
//
//  Created by Azmi Muhammad on 26/12/19.
//  Copyright © 2019 Jualan Mu. All rights reserved.
//

import Alamofire

class ApiService {
    private let api: Api!
    private let baseUrl: String!
    
    init(api: Api, baseUrl: String) {
        self.api = api
        self.baseUrl = baseUrl
    }
    
    func callApi(onSuccess: OnSuccess, onFailed: OnFailed) {
        let url: String = baseUrl + api.module.rawValue
        
        Alamofire.request(url, method: api.httpMethod, parameters: api.parameters, encoding: JSONEncoding.default, headers: api.headers).responseJSON { response in
            switch response.result {
            case .success:
                guard let responseJSON = response.result.value as? [String:Any] else {return}
                if let meta = responseJSON["Meta"] as? [String:Any], let status = meta["status"] as? Int, let data = responseJSON["Data"] as? [String:Any] {
                    if status == 200 || status == 201 {
                        onSuccess?(data)
                    } else {
                        let error: NSError = NSError(domain: "Terjadi kesalahan pada aplikasi. Coba lagi", code: 1000, userInfo: nil)
                        onFailed?(error)
                    }
                }
                break
            case .failure(let error):
                onFailed?(error)
                break
            }
        }
    }
}
