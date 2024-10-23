//
//  StorageMigrationTest.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import XCTest
@testable import factorySample

final class StorageMigrationTests: BaseStorageTests {
    var repository: UserDataRepository!
    
    override func setUp() {
        super.setUp()
        repository = UserDataRepository(storageType: .userDefaults, factory: MigrationTestFactory.self)
    }
    
    func testDataFormatMigration() throws {
        // Given
        let oldFormatData = """
        {
            "id": "legacy_1",
            "full_name": "Old User",
            "mail": "old@test.com",
            "status": 1
        }
        """.data(using: .utf8)!
        
        MigrationTestFactory.mockStorage?.saveOldFormatData(oldFormatData, for: "legacy_1")
        
        // When
        let migratedUser = try repository.getUser(id: "legacy_1")
        
        // Then
        XCTAssertNotNil(migratedUser)
        XCTAssertEqual(migratedUser?.name, "Old User")
        XCTAssertEqual(migratedUser?.email, "old@test.com")
        XCTAssertEqual(migratedUser?.isActive, true)
    }
    
    func testBackwardCompatibility() throws {
        // Given
        let modernUser = User(
            id: "modern_1",
            name: "Modern User",
            email: "modern@test.com",
            isActive: true
        )
        
        // When
        try repository.saveUser(modernUser)
        
        // Then
        let oldFormatData = MigrationTestFactory.mockStorage?.getOldFormatData(for: modernUser.id)
        XCTAssertNotNil(oldFormatData, "Old format data should not be nil")
        
        if let oldData = oldFormatData {
            let json = try JSONSerialization.jsonObject(with: oldData) as? [String: Any]
            XCTAssertNotNil(json, "JSON parsing should succeed")
            XCTAssertEqual(json?["full_name"] as? String, modernUser.name)
            XCTAssertEqual(json?["mail"] as? String, modernUser.email)
            XCTAssertEqual(json?["status"] as? Int, 1)
        }
    }
    
    // Ek test ekleyelim - eski formattan yeni formata geçiş
    func testForwardMigration() throws {
        // Given
        let oldFormatJson: [String: Any] = [
            "id": "old_1",
            "full_name": "Old User",
            "mail": "old@test.com",
            "status": 1
        ]
        let oldFormatData = try JSONSerialization.data(withJSONObject: oldFormatJson)
        MigrationTestFactory.mockStorage?.saveOldFormatData(oldFormatData, for: "old_1")
        
        // When
        let migratedUser = try repository.getUser(id: "old_1")
        
        // Then
        XCTAssertNotNil(migratedUser)
        XCTAssertEqual(migratedUser?.name, "Old User")
        XCTAssertEqual(migratedUser?.email, "old@test.com")
        XCTAssertEqual(migratedUser?.isActive, true)
    }
}
