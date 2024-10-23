//
//  StorageSecurityTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class StorageSecurityTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .keychain, factory: SecureTestFactory.self)
    }
    
    override func tearDown() {
        try? SecureTestFactory.mockStorage?.clearAll()
        super.tearDown()
    }
    
    func testDataEncryption() throws {
        // Given
        let sensitiveUser = User(
            id: "sensitive",
            name: "Secret User",
            email: "secret@test.com",
            isActive: true
        )
        
        // When
        try repository.saveUser(sensitiveUser)
        
        // Then
        XCTAssertTrue(SecureTestFactory.mockStorage?.isDataEncrypted ?? false)
        let rawData = SecureTestFactory.mockStorage?.getRawData(for: sensitiveUser.id)
        XCTAssertNotNil(rawData)
        XCTAssertThrowsError(try JSONDecoder().decode(User.self, from: rawData!))
    }
    
    func testSecureDataWipe() throws {
        // Given
        try repository.saveUser(testUser)
        
        // When
        try repository.deleteUser(id: testUser.id)
        
        // Then
        XCTAssertTrue(SecureTestFactory.mockStorage?.isSecurelyWiped ?? false)
        XCTAssertNil(SecureTestFactory.mockStorage?.getRawData(for: testUser.id))
    }
}
