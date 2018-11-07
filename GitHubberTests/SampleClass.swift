//
//  SampleClass.swift
//  GitHubberTests
//
//  Created by user on 11/6/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
@testable import GitHubber

class SampleClass: JsonCodable {
    public var test:String = "this is a string"
    public var test2:Int = 123
    public var arr:Array = [1 ,2 ,3 ,4 ]
    public var dict:[String:Int] = ["test":123, "waht":234]
    
    init() {
        
    }
    
    
    
}
