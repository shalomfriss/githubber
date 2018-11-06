//
//  NetworkManager.swift
//  GitHubber
//
//  Created by user on 11/5/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire

enum NetworkManagerError:Error {
    case couldNotCreateUrl
    case nilDataOrParseError
}


/// A network manager that adheres to the NetworkManagerProtocol
class NetworkManager {
    public static var shared = NetworkManager()
    
    private var headers = [
        "Authorization": "Basic \("somecreds")",
        "Accept": "application/json",
        "Content-Type": "application/json" ]
    
    private var encoding:Any = URLEncoding.default
    private var services:[String:Service] = [:]
    
    
    //MARK:- Getter / Setter
    /// Set the encoding for network calls
    ///
    /// - Parameter anEncoding:Any - An encoding which will have to be casted right before the call
    public func setEncoding(anEncoding:Any) {
        self.encoding = anEncoding
    }
    
    public func setHeaders(newHeaders:[String:String]) {
        self.headers = newHeaders
    }
    
    
    
    //MARK:- API
    
    public func runService(serviceName:String, onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> ()) {
        if let serviceClass = services[serviceName] {
            serviceClass.execute(onSuccess: onSuccess, onError: onError)
        }
    }
    
    
    
    //MARK:- Data methods
    /// Simple get method that defaults to returning json
    ///
    /// - Parameters:
    ///   - url:
    ///   - success:
    ///   - error:
    public func getData(url:String, onSuccess: @escaping (Data?)  -> (), onError: @escaping (Error?) -> (), asData:Bool = false) {
        Alamofire.request(url).responseData { response in
            switch response.result {
            case .success(_):
                onSuccess(response.data)
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    
    /// Simple post call that defaults to json
    ///
    /// - Parameters:
    ///   - url:
    ///   - data:
    ///   - success:
    ///   - error:
    public func postData(url:String, data:[String:Any]?, onSuccess: @escaping (Data?)  -> (), onError: @escaping (Error?) -> ()) {
        Alamofire.request(url, method: .get, parameters: data, encoding: self.encoding as! URLEncoding, headers: self.headers) .responseData { response in
            switch response.result {
            case .success(_):
                onSuccess(response.data)
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    public func putData(url:String, data:[String:Any]?, onSuccess: @escaping (Data?)  -> (), onError: @escaping (Error?) -> ()) {
        Alamofire.request(url, method: .put, parameters: data, encoding: self.encoding as! URLEncoding, headers: self.headers) .responseData { response in
            switch response.result {
            case .success(_):
                onSuccess(response.data)
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    public func deleteData(url:String, onSuccess: @escaping (Data?)  -> (), onError: @escaping (Error?) -> ()) {
        Alamofire.request(url, method: .delete) .responseData { response in
            switch response.result {
            case .success(_):
                onSuccess(response.data)
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    
    
    
    
    
    //MARK:- JSON methods
    /// Simple get method that defaults to returning json
    ///
    /// - Parameters:
    ///   - url:
    ///   - success:
    ///   - error:
    public func get(url:String, onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> (), asData:Bool = false) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(_):
                if let json = self.encode(data: response.data) {
                    onSuccess(json)
                }
                else {
                    onError(NetworkManagerError.nilDataOrParseError)
                }
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    
    /// Simple post call that defaults to json
    ///
    /// - Parameters:
    ///   - url:
    ///   - data:
    ///   - success:
    ///   - error:
    public func post(url:String, data:[String:Any]?, onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> ()) {
        Alamofire.request(url, method: .post, parameters: data, encoding: self.encoding as! URLEncoding, headers: self.headers) .responseJSON { response in
            switch response.result {
            case .success(_):
                if let json = self.encode(data: response.data) {
                    onSuccess(json)
                }
                else {
                    onError(NetworkManagerError.nilDataOrParseError)
                }
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    public func put(url:String, data:[String:Any]?, onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> ()) {
        Alamofire.request(url, method: .put, parameters: data, encoding: self.encoding as! URLEncoding, headers: self.headers) .responseJSON { response in
            switch response.result {
            case .success(_):
                if let json = self.encode(data: response.data) {
                    onSuccess(json)
                }
                else {
                    onError(NetworkManagerError.nilDataOrParseError)
                }
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    public func delete(url:String, onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> ()) {
        Alamofire.request(url, method: .delete) .responseJSON { response in
            switch response.result {
            case .success(_):
                if let json = self.encode(data: response.data) {
                    onSuccess(json)
                }
                else {
                    onError(NetworkManagerError.nilDataOrParseError)
                }
            case .failure(_):
                onError(response.error)
            }
        }
    }
    
    //MARK:- Utils
    
    
    /// Convert the data to a json dictionary
    ///
    /// - Parameter data:
    /// - Returns: [String:Any]?
    public func encode(data:Data?) -> [String:Any]? {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return json
            }
            catch {
                return nil
            }
        }
        return nil
    }
    
    public func addService(serviceName:String, serviceClass:Service) {
        services.updateValue(serviceClass, forKey: serviceName)
    }
    
    public func removeService(serviceName:String) {
        services.removeValue(forKey: serviceName)
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability! , &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    //MARK:- Manual
    public func manualRequest(url:String, method: String, params: [String: String], onSuccess: @escaping ([String:Any]?)  -> (), onError: @escaping (Error?) -> () ){
        if let theUrl = URL(string: url) {
            
            var request = URLRequest(url: theUrl)
            let postString = params.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
            
            if method == "POST" {
                request.httpMethod = "POST"
                request.httpBody = postString.data(using: String.Encoding.utf8)
            }
            else if method == "GET" {
                request.httpMethod = "GET"
            }
            else if method == "PUT" {
                request.httpMethod = "PUT"
                request.httpBody = postString.data(using: String.Encoding.utf8)
            }
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                if let json = self.encode(data: data) {
                    onSuccess(json)
                }
                else {
                    onError(NetworkManagerError.nilDataOrParseError)
                }
            }
            task.resume()
        }
    }
    
}

