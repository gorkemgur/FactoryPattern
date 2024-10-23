//
//  CoreDataStorageTests.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class CoreDataStorageTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .coreData(modelName: "Test"), factory: CoreDataTestFactory.self)
    }
    
    override func tearDown() {
        try? CoreDataTestFactory.mockStorage?.clearAll()
        CoreDataTestFactory.mockStorage = nil
        repository = nil
        super.tearDown()
    }
    
    func testBatchOperations() throws {
        // Given
        let users = (0..<100).map { index in
            User(id: "user_\(index)",
                 name: "User \(index)",
                 email: "user\(index)@test.com",
                 isActive: true)
        }
        
        // When
        try users.forEach { try repository.saveUser($0) }
        try CoreDataTestFactory.mockStorage?.clearAll()
        
        // Then
        XCTAssertEqual(CoreDataTestFactory.mockStorage?.saveCallCount, users.count)
        XCTAssertEqual(CoreDataTestFactory.mockStorage?.batchOperationCount, 1)
    }
    
    func testCoreDataErrorHandling() throws {
        // Given
        let user = testUser
        CoreDataTestFactory.mockStorage?.simulateCoreDataError()
        
        // When/Then
        XCTAssertThrowsError(try repository.saveUser(user)) { error in
            guard case StorageError.saveError = error else {
                XCTFail("Wrong error type")
                return
            }
        }
    }
    
    // Ek testler ekleyelim
    func testFetchOperation() throws {
        // Given
        let user = testUser
        
        // When
        try repository.saveUser(user)
        let fetchedUser = try repository.getUser(id: user.id)
        
        // Then
        XCTAssertEqual(fetchedUser, user)
        XCTAssertEqual(CoreDataTestFactory.mockStorage?.fetchCallCount, 1)
    }
    
    func testDeleteOperation() throws {
        // Given
        let user = testUser
        try repository.saveUser(user)
        
        // When
        try repository.deleteUser(id: user.id)
        
        // Then
        XCTAssertEqual(CoreDataTestFactory.mockStorage?.deleteCallCount, 1)
        let fetchedUser = try repository.getUser(id: user.id)
        XCTAssertNil(fetchedUser)
    }
    
    func testErrorOnFetch() throws {
        // Given
        let user = testUser
        try repository.saveUser(user)
        CoreDataTestFactory.mockStorage?.simulateCoreDataError()
        
        // When/Then
        XCTAssertThrowsError(try repository.getUser(id: user.id)) { error in
            guard case StorageError.fetchError = error else {
                XCTFail("Wrong error type")
                return
            }
        }
    }
}
