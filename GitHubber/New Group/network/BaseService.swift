//
//  BaseService.swift
//  GitHubber
//
//  Created by user on 11/6/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

enum BaseServiceRequestType {
    case post
    case get
    case put
    case delete
}

class BaseService:Service {
    public var url:String = ""
    public var data:[String:Any]? = nil
    public var type:BaseServiceRequestType = .get
    
    public func execute(onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> ()) {
        switch(type) {
        case .get:
            NetworkManager.shared.get(url: url, onSuccess: onSuccess, onError: onError)
        case .post:
            NetworkManager.shared.post(url: url, data: data ?? nil, onSuccess: onSuccess, onError: onError)
        case .put:
            NetworkManager.shared.put(url: url, data: data ?? nil, onSuccess: onSuccess, onError: onError)
        case .delete:
            break
        }
        
    }
}
