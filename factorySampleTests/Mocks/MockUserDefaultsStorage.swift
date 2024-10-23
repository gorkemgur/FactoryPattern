//
//  MockUserDefaultsStorage.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

final class MockUserDefaultsStorage: StorageServiceProtocol {
    private var storage: [String: Data] = [:]
    var saveCallCount = 0
    var fetchCallCount = 0
    var deleteCallCount = 0
    var shouldSimulateError = false
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        saveCallCount += 1
        let data = try JSONEncoder().encode(item)
        storage[key] = data
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        fetchCallCount += 1
        guard let data = storage[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(for key: String) throws {
        deleteCallCount += 1
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
    }
}
