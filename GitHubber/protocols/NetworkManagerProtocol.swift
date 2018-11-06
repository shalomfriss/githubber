//
//  NetworkManagerProtocol.swift
//  GitHubber
//
//  Created by user on 11/5/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func setHeaders(newHeaders:[String:String])
    func setEncoding(anEncoding:Any)
    func get(url:String, onSuccess: @escaping (Data?)  -> (), onError: @escaping (Error?) -> ())
    func post(url:String, data:[String:Any]?, onSuccess: @escaping (Data?)  -> (), onError: @escaping (Error?) -> ())
    
}
