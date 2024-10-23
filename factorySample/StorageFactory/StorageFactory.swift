//
//  StorageFactory.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

protocol StorageFactoryProtocol {
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol
}

// MARK: - Production Factory
final class StorageFactory: StorageFactoryProtocol {
    static func createStorage(_ type: StorageType) -> StorageServiceProtocol {
        switch type {
        case .userDefaults:
            return UserDefaultsStorage()
        case .keychain:
            return KeychainStorage()
        case .coreData(let modelName):
            return CoreDataStorage(containerName: modelName)
        }
    }
}
