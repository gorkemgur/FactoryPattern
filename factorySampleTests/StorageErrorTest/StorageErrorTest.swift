//
//  StorageErrorTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class StorageErrorTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .userDefaults, factory: ErrorTestFactory.self)
    }
    
    func testDiskFullError() throws {
        // Given
        ErrorTestFactory.mockStorage?.simulateDiskFullError = true
        
        // When/Then
        XCTAssertThrowsError(try repository.saveUser(testUser)) { error in
            guard case StorageError.saveError(let message) = error else {
                XCTFail("Wrong error type")
                return
            }
            XCTAssertTrue(message.contains("disk full"))
        }
    }
    
    func testCorruptedDataError() throws {
        // Given
        try repository.saveUser(testUser)
        ErrorTestFactory.mockStorage?.simulateCorruptedData = true
        
        // When/Then
        XCTAssertThrowsError(try repository.getUser(id: testUser.id)) { error in
            guard case StorageError.fetchError(let message) = error else {
                XCTFail("Wrong error type")
                return
            }
            XCTAssertTrue(message.contains("corrupted"))
        }
    }
    
    func testConcurrentAccessErrors() {
        // Given
        let expectation = XCTestExpectation(description: "Concurrent access completed")
        let queue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)
        ErrorTestFactory.mockStorage?.simulateConcurrentAccessError = true
        
        // When
        for i in 0..<10 {
            queue.async {
                let user = User(
                    id: "user_\(i)",
                    name: "User \(i)",
                    email: "user\(i)@test.com",
                    isActive: true
                )
                
                // try-catch bloğu içinde error handling
                do {
                    try self.repository.saveUser(user)
                    XCTFail("Should throw concurrent access error")
                } catch {
                    if case StorageError.saveError(let message) = error {
                        XCTAssertTrue(message.contains("concurrent"))
                    } else {
                        XCTFail("Wrong error type: \(error)")
                    }
                }
            }
        }
        
        queue.async(flags: .barrier) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
