//
//  PersistenceManagerTests.swift
//  GitHubberTests
//
//  Created by user on 11/6/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import XCTest
@testable import GitHubber

class PersistenceManagerTests: XCTestCase {
    
    
    /*
    func testArchive() {
        let sampleClass = SampleClass()
        sampleClass.test = "custom test"
        
        
        PersistenceManager.archive(object: sampleClass, fileName: "test1", completion: { error in
            
            if(error == nil) {
                XCTAssert(true)
            } else {
                XCTAssert(false)
            }
        })
        
    }
    
    func testUnarchive() {
        if let newSampleClass:SampleClass =  PersistenceManager.unarchive(fileName: "test1") {
            XCTAssert(newSampleClass.test2 == 123)
            XCTAssert(newSampleClass.test == "custom test")
            XCTAssert(newSampleClass.arr == [1 ,2 ,3 ,4 ])
            XCTAssert(newSampleClass.dict == ["test":123, "waht":234])
            
        } else {
            XCTAssert(false)
        }
    }
    */
    
    func testUnarchiveMiss() {
        
        if let _:SampleClass = PersistenceManager.unarchive(fileName: "wrongfile") {
            XCTAssert(false)
        } else {
            XCTAssert(true)
        }
        
    }
}
