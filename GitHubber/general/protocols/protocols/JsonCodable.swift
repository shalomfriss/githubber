//
//  JsonCodable.swift
//  GitHubber
//
//  Created by user on 11/5/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation

/// Mappable
protocol JsonCodable: Codable {
    init?(jsonString: String)
    func jsonEncoded() -> String?
}

extension JsonCodable {
    
    /// initialize from a json string
    ///
    /// - Parameter jsonString:String
    init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
    
    
    /// return encoded json string
    ///
    /// - Returns: string?
    func jsonEncoded() -> String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            return nil
        }
    }
    
}
