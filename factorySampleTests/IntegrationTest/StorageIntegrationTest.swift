//
//  StorageIntegrationTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class StorageIntegrationTests: BaseStorageTests {
    var userDefaultsRepository: UserDataRepository!
    var keychainRepository: UserDataRepository!
    var coreDataRepository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        userDefaultsRepository = UserDataRepository(storageType: .userDefaults, factory: ErrorTestFactory.self)
        keychainRepository = UserDataRepository(storageType: .keychain, factory: SecureTestFactory.self)
        coreDataRepository = UserDataRepository(storageType: .coreData(modelName: "TestModel"), factory: ErrorTestFactory.self)
    }
    
    func testCrossStorageDataConsistency() throws {
        // Given
        let user = testUser
        
        // When
        try userDefaultsRepository.saveUser(user)
        try keychainRepository.saveUser(user)
        try coreDataRepository.saveUser(user)
        
        // Then
        let userDefaultsUser = try userDefaultsRepository.getUser(id: user.id)
        let keychainUser = try keychainRepository.getUser(id: user.id)
        let coreDataUser = try coreDataRepository.getUser(id: user.id)
        
        XCTAssertEqual(userDefaultsUser, user)
        XCTAssertEqual(keychainUser, user)
        XCTAssertEqual(coreDataUser, user)
    }
    
    func testStorageTypeSpecificBehavior() throws {
        // Given
        let sensitiveUser = User(
            id: "sensitive",
            name: "Sensitive User",
            email: "sensitive@test.com",
            isActive: true
        )
        
        // When
        try keychainRepository.saveUser(sensitiveUser)
        
        // Then
        XCTAssertTrue(SecureTestFactory.mockStorage?.isDataEncrypted ?? false)
    }
}
