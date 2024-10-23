//
//  StorageLifeCycleTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class StorageLifecycleTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .userDefaults, factory: LifecycleTestFactory.self)
    }
    
    func testAppTermination() throws {
        // Given
        try repository.saveUser(testUser)
        
        // When
        LifecycleTestFactory.mockStorage?.simulateAppTermination()
        
        // Then
        XCTAssertTrue(LifecycleTestFactory.mockStorage?.isDataPersisted ?? false)
        let savedUser = try repository.getUser(id: testUser.id)
        XCTAssertEqual(savedUser, testUser)
    }
    
    func testBackgroundModeTransition() throws {
        // Given
        try repository.saveUser(testUser)
        
        // When
        LifecycleTestFactory.mockStorage?.simulateBackgroundTransition()
        
        // Then
        XCTAssertTrue(LifecycleTestFactory.mockStorage?.isDataSynced ?? false)
        XCTAssertTrue(LifecycleTestFactory.mockStorage?.isResourcesOptimized ?? false)
    }
    
    func testLowMemoryHandling() throws {
        // Given
        let users = (0..<100).map { index in
            User(id: "user_\(index)",
                 name: "User \(index)",
                 email: "user\(index)@test.com",
                 isActive: true)
        }
        
        // When
        try users.forEach { try repository.saveUser($0) }
        LifecycleTestFactory.mockStorage?.simulateLowMemory()
        
        // Then
        XCTAssertTrue(LifecycleTestFactory.mockStorage?.isMemoryOptimized ?? false)
        let firstUser = try repository.getUser(id: "user_0")
        XCTAssertNotNil(firstUser)
    }
}
