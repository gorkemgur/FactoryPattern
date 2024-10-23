//
//  BaseStorageTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

class BaseStorageTests: XCTestCase {
    var testUser: User = User(
            id: "test_123",
            name: "Test User",
            email: "test@example.com",
            isActive: true
        )
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
