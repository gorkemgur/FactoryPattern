//
//  UserDataRepository.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

final class UserDataRepository {
    private let storage: StorageServiceProtocol
    private let factory: StorageFactoryProtocol.Type
    
    init(storageType: StorageType, factory: StorageFactoryProtocol.Type = StorageFactory.self) {
        self.factory = factory
        self.storage = factory.createStorage(storageType)
    }
    
    func saveUser(_ user: User) throws {
        try storage.save(user, for: user.id)
    }
    
    func getUser(id: String) throws -> User? {
        try storage.fetch(for: id)
    }
    
    func deleteUser(id: String) throws {
        try storage.delete(for: id)
    }
}

