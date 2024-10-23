//
//  MockCoreDataStorage.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

final class MockCoreDataStorage: StorageServiceProtocol {
    private var storage: [String: Data] = [:]
    var saveCallCount = 0
    var fetchCallCount = 0
    var deleteCallCount = 0
    var batchOperationCount = 0
    var shouldSimulateError = false
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        if shouldSimulateError {
            throw StorageError.saveError("CoreData save error")
        }
        saveCallCount += 1
        let data = try JSONEncoder().encode(item)
        storage[key] = data
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        if shouldSimulateError {
            throw StorageError.fetchError("CoreData fetch error")
        }
        fetchCallCount += 1
        guard let data = storage[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(for key: String) throws {
        if shouldSimulateError {
            throw StorageError.deleteError("CoreData delete error")
        }
        deleteCallCount += 1
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        if shouldSimulateError {
            throw StorageError.deleteError("CoreData removeAll error")
        }
        storage.removeAll()
        batchOperationCount += 1
    }
    
    func simulateCoreDataError() {
        shouldSimulateError = true
    }
}
