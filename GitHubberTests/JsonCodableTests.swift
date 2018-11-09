//
//  JsonCodableTests.swift
//  GitHubberTests
//
//  Created by user on 11/8/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import XCTest
@testable import GitHubber

class JsonCodableTests: XCTestCase {

    func testJsonCodable() {
        let sampleClass = SampleClass()
        sampleClass.test2 = 456
        let jsonString = sampleClass.jsonEncoded()!
        let newSampleClass = SampleClass(jsonString: jsonString)!
        
        
        XCTAssert(newSampleClass.test2 == 456)
        XCTAssert(newSampleClass.test == "this is a string")
        XCTAssert(newSampleClass.arr == [1 ,2 ,3 ,4 ])
        XCTAssert(newSampleClass.dict == ["test":123, "waht":234])
    }

}
