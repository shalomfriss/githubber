//
//  PersistenceManager.swift
//  GitHubber
//
//  Created by user on 11/6/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

enum PersistenceError:Error {
    case couldNotEncode
    case couldNotWriteFile
    case couldNotReadFile
    case couldNotInitialize
}

/// PersistenceManager will very easily save and get your data to disk securely
class PersistenceManager {
    
    public static var requireSecureCoding:Bool = true
    public static var cacheDirectoryName:String = "cache"
    
    
    /// Get the cache directory, which is the document directory with the cache directory name appended
    class private func cacheDirectory() throws -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let cacheDir = paths[0].appendingPathComponent(PersistenceManager.cacheDirectoryName)
        
        do {
            try FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw PersistenceError.couldNotInitialize
        }
        
        return cacheDir
    }
    
    
    /*
    class func filePath(key:String) -> String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent(key).path)
    }
    */
    
    
    
    //MARK:- Archive json
    /// Archive a JsonCodable object
    class public func archive(object:JsonCodable, fileName:String, completion: ((Error?) -> ())? ){
        
        
        //DispatchQueue.global(qos: .background).sync {
            if let jsonString = object.jsonEncoded() {
                do {
                    let filePath = try cacheDirectory().appendingPathComponent(fileName)
                    
                    //let filePath = try cacheDirectory().appendingPathComponent(fileName)
                    let result = NSKeyedArchiver.archiveRootObject(jsonString, toFile: filePath.absoluteString)
                    
                    if let completion = completion {
                        if(result == false){
                            completion(PersistenceError.couldNotWriteFile)
                        } else {
                            completion(nil)
                        }
                    }
                    
                    return
                    
                    
                } catch {
                    //throw PersistenceError.couldNotWriteFile
                    if let completion = completion {
                        completion(PersistenceError.couldNotWriteFile)
                    }
                    
                    print("Could not persist\(fileName)")
                }
            } else {
                //throw PersistenceError.couldNotEncode
                if let completion = completion {
                    completion(PersistenceError.couldNotEncode)
                }
                
                print("Could not persist\(fileName)")
            }
        //}
        
    }
    
    
    /// Unarchive an object based on the filename
    class public func unarchive<T:JsonCodable>(fileName:String) -> T? {
        var result:T? = nil
        //DispatchQueue.global(qos: .background).sync {
            do {
                
                let filePath = try cacheDirectory().appendingPathComponent(fileName)
                //let url = URL(string: filePath)
                print("UNARCHIVE")
                guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.absoluteString) as? String else { return nil }
                
                print("HERE")
                print(data)
                
                let returnClass = T.init(jsonString: data)
                result = returnClass
                
                /*
                let fileData = try Data(contentsOf: URL(filePath(key: fileName)))
                if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(fileData) as? String
                {
                    let returnClass = T.init(jsonString: data)
                    result = returnClass
                }
                */
                
                //Result should be nil
            } catch  {
                //Result should be nil
                return nil
            }
       // }
        return result
    }
}
