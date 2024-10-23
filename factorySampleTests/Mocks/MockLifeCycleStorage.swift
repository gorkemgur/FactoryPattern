//
//  MockLifeCycleStorage.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

final class MockLifecycleStorage: StorageServiceProtocol {
    private var storage: [String: Data] = [:]
    var isDataPersisted = false
    var isDataSynced = false
    var isResourcesOptimized = false
    var isMemoryOptimized = false
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        storage[key] = try JSONEncoder().encode(item)
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(for key: String) throws {
        storage.removeValue(forKey: key)
    }
    
    func clearAll() throws {
        storage.removeAll()
    }
    
    func simulateAppTermination() {
        isDataPersisted = true
    }
    
    func simulateBackgroundTransition() {
        isDataSynced = true
        isResourcesOptimized = true
    }
    
    func simulateLowMemory() {
        isMemoryOptimized = true
    }
}
