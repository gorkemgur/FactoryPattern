//
//  MockMigrationStorage.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

final class MockMigrationStorage: StorageServiceProtocol {
    private var storage: [String: Data] = [:]
    private var oldFormatStorage: [String: Data] = [:]
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        // Modern format'ta kaydet
        storage[key] = try JSONEncoder().encode(item)
        
        // Eski format'a da dönüştür ve kaydet
        if let user = item as? User {
            let oldFormatDict: [String: Any] = [
                "id": user.id,
                "full_name": user.name,
                "mail": user.email,
                "status": user.isActive ? 1 : 0
            ]
            oldFormatStorage[key] = try JSONSerialization.data(withJSONObject: oldFormatDict)
        }
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        if let data = storage[key] {
            return try JSONDecoder().decode(T.self, from: data)
        }
        
        // Try to migrate old format data
        if let oldData = oldFormatStorage[key],
           let json = try? JSONSerialization.jsonObject(with: oldData) as? [String: Any] {
            let user = User(
                id: json["id"] as? String ?? "",
                name: json["full_name"] as? String ?? "",
                email: json["mail"] as? String ?? "",
                isActive: (json["status"] as? Int ?? 0) == 1
            )
            return user as? T
        }
        return nil
    }
    
    func delete(for key: String) throws {
        storage.removeValue(forKey: key)
        oldFormatStorage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
        oldFormatStorage.removeAll()
    }
    
    func saveOldFormatData(_ data: Data, for key: String) {
        oldFormatStorage[key] = data
    }
    
    func getOldFormatData(for key: String) -> Data? {
        return oldFormatStorage[key]
    }
}
