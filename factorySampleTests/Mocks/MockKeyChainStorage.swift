//
//  MockKeyChainStorage.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

final class MockKeyChainStorage: StorageServiceProtocol {
    private var storage: [String: Data] = [:]
    var isDataEncrypted = false
    var isSecurelyWiped = false
    var simulateError = false
    var accessCount = 0 // Access count property ekledik
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        accessCount += 1 // Save işleminde artır
        let data = try JSONEncoder().encode(item)
        // Simulate encryption
        storage[key] = Data(data.reversed())
        isDataEncrypted = true
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        accessCount += 1 // Fetch işleminde artır
        guard let data = storage[key] else { return nil }
        // Simulate decryption
        let decryptedData = Data(data.reversed())
        return try JSONDecoder().decode(T.self, from: decryptedData)
    }
    
    func delete(for key: String) throws {
        accessCount += 1 // Delete işleminde artır
        storage.removeValue(forKey: key)
        isSecurelyWiped = true
    }
    
    func clearAll() throws {
        accessCount += 1 // ClearAll işleminde artır
        storage.removeAll()
        isSecurelyWiped = true
    }
    
    func getRawData(for key: String) -> Data? {
        accessCount += 1 // GetRawData işleminde artır
        return storage[key]
    }
    
    func simulateKeychainError() throws {
        simulateError = true
        let dummyUser = User(id: "test", name: "test", email: "test@test.com", isActive: true)
        try save(dummyUser, for: "test")
        throw StorageError.saveError("Save Error")
    }
}

