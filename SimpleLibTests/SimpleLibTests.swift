//
//  SimpleLibTests.swift
//  SimpleLibTests
//
//  Created by Nehal Patel on 4/20/18.
//  Copyright © 2018 LIL. All rights reserved.
//

import XCTest
@testable import SimpleLib

class SimpleLibTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let f = Foo();
        let b = f;
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
