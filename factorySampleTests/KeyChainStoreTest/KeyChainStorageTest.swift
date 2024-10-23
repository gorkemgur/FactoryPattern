//
//  KeyChainStorageTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class KeychainStorageTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .keychain, factory: SecureTestFactory.self)
    }
    
    override func tearDown() {
        try? SecureTestFactory.mockStorage?.clearAll()
        SecureTestFactory.mockStorage = nil
        repository = nil
        super.tearDown()
    }
    
    func testSecureStorage() throws {
        // Given
        let sensitiveUser = User(
            id: "sensitive_123",
            name: "Sensitive User",
            email: "sensitive@test.com",
            isActive: true
        )
        
        // When
        try repository.saveUser(sensitiveUser)
        let savedUser = try repository.getUser(id: sensitiveUser.id)
        
        // Then
        XCTAssertEqual(savedUser, sensitiveUser)
        XCTAssertEqual(SecureTestFactory.mockStorage?.accessCount, 2)
    }
    
    func testKeychainErrorHandling() throws {
        // Given
        guard let storage = SecureTestFactory.mockStorage else {
            XCTFail("Mock storage should not be nil")
            return
        }
        
        // When/Then
        XCTAssertThrowsError(try storage.simulateKeychainError()) { error in
            guard case StorageError.saveError = error else {
                XCTFail("Wrong error type")
                return
            }
        }
    }
    
    func testEncryptionStatus() throws {
        // Given
        let user = testUser
        
        // When
        try repository.saveUser(user)
        
        // Then
        XCTAssertTrue(SecureTestFactory.mockStorage?.isDataEncrypted ?? false)
    }
}


