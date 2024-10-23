//
//  TestFactories.swift
//  factorySampleTests
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
@testable import factorySample

class ErrorTestFactory: StorageFactoryProtocol {
    static var mockStorage: MockErrorStorage?
    
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        let storage = MockErrorStorage()
        mockStorage = storage
        return storage
    }
}

class SecureTestFactory: StorageFactoryProtocol {
    static var mockStorage: MockKeyChainStorage?
    
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        let storage = MockKeyChainStorage()
        mockStorage = storage
        return storage
    }
}

class MigrationTestFactory: StorageFactoryProtocol {
    static var mockStorage: MockMigrationStorage?
    
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        let storage = MockMigrationStorage()
        mockStorage = storage
        return storage
    }
}

class LifecycleTestFactory: StorageFactoryProtocol {
    static var mockStorage: MockLifecycleStorage?
    
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        let storage = MockLifecycleStorage()
        mockStorage = storage
        return storage
    }
}

final class CoreDataTestFactory: StorageFactoryProtocol {
    static var mockStorage: MockCoreDataStorage?
    
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        let storage = MockCoreDataStorage()
        mockStorage = storage
        return storage
    }
}

final class UserDefaultsTestFactory: StorageFactoryProtocol {
    static var mockStorage: MockUserDefaultsStorage?
    
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        let storage = MockUserDefaultsStorage()
        mockStorage = storage
        return storage
    }
}
