//
//  UserDefaultsStorageTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class UserDefaultsStorageTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .userDefaults, factory: UserDefaultsTestFactory.self)
    }
    
    override func tearDown() {
        try? UserDefaultsTestFactory.mockStorage?.clearAll()
        UserDefaultsTestFactory.mockStorage = nil
        repository = nil
        super.tearDown()
    }
    
    func testSaveAndRetrieveUser() throws {
        // Given
        let user = testUser
        
        // When
        try repository.saveUser(user)
        let savedUser = try repository.getUser(id: user.id)
        
        // Then
        XCTAssertEqual(UserDefaultsTestFactory.mockStorage?.saveCallCount, 1)
        XCTAssertEqual(UserDefaultsTestFactory.mockStorage?.fetchCallCount, 1)
        XCTAssertEqual(savedUser, user)
    }
    
    func testUserDefaultsPersistence() throws {
        // Given
        let users = (0..<5).map { index in
            User(id: "user_\(index)",
                 name: "User \(index)",
                 email: "user\(index)@test.com",
                 isActive: true)
        }
        
        // When
        try users.forEach { try repository.saveUser($0) }
        
        // Then
        for user in users {
            let savedUser = try repository.getUser(id: user.id)
            XCTAssertEqual(savedUser, user)
        }
        XCTAssertEqual(UserDefaultsTestFactory.mockStorage?.saveCallCount, users.count)
    }
    
    // Ek test senaryoları
    func testDeleteUser() throws {
        // Given
        let user = testUser
        try repository.saveUser(user)
        
        // When
        try repository.deleteUser(id: user.id)
        let deletedUser = try repository.getUser(id: user.id)
        
        // Then
        XCTAssertEqual(UserDefaultsTestFactory.mockStorage?.deleteCallCount, 1)
        XCTAssertNil(deletedUser)
    }
    
    func testUpdateUser() throws {
        // Given
        let user = testUser
        try repository.saveUser(user)
        
        let updatedUser = User(
            id: user.id,
            name: "Updated Name",
            email: user.email,
            isActive: user.isActive
        )
        
        // When
        try repository.saveUser(updatedUser)
        let savedUser = try repository.getUser(id: user.id)
        
        // Then
        XCTAssertEqual(savedUser?.name, "Updated Name")
        XCTAssertEqual(UserDefaultsTestFactory.mockStorage?.saveCallCount, 2)
    }
    
    func testNonExistentUser() throws {
        // When
        let user = try repository.getUser(id: "non-existent")
        
        // Then
        XCTAssertNil(user)
        XCTAssertEqual(UserDefaultsTestFactory.mockStorage?.fetchCallCount, 1)
    }
}
