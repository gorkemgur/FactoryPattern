//
//  MockErrorStorage.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

final class MockErrorStorage: StorageServiceProtocol {
    private var storage: [String: Data] = [:]
    var simulateDiskFullError = false
    var simulateCorruptedData = false
    var simulateConcurrentAccessError = false
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        if simulateDiskFullError {
            throw StorageError.saveError("disk full error")
        }
        if simulateConcurrentAccessError {
            throw StorageError.saveError("concurrent access error")
        }
        storage[key] = try JSONEncoder().encode(item)
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        if simulateCorruptedData {
            throw StorageError.fetchError("corrupted data error")
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(for key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
    }
}
