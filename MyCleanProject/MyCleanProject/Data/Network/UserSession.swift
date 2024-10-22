//
//  UserSession.swift
//  MyCleanProject
//
//  Created by elly on 10/22/24.
//

import Foundation
import Alamofire

// Session

public protocol SessionProtocol {
    func request(_ convertible: any URLConvertible,
                 method: HTTPMethod,
                 parameters: Parameters?,
                 headers: HTTPHeaders?) -> DataRequest
}

class UserSession: SessionProtocol {
    private var session: Session
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(_ convertible: any URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: Parameters? = nil,
                 headers: HTTPHeaders? = nil) -> DataRequest {
        return session.request(convertible,
                        method: method,
                        parameters: parameters,
                        headers: headers)
    }
}
