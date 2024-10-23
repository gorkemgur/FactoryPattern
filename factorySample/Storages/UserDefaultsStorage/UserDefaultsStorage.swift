//
//  UserDefaultsStorage.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation
final class UserDefaultsStorage: StorageServiceProtocol {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func save<T: Codable>(_ item: T, for key: String) throws {
        do {
            let data = try JSONEncoder().encode(item)
            defaults.set(data, forKey: key)
        } catch {
            throw StorageError.saveError("UserDefaults save failed: \(error.localizedDescription)")
        }
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw StorageError.fetchError("UserDefaults fetch failed: \(error.localizedDescription)")
        }
    }
    
    func delete(for key: String) throws {
        defaults.removeObject(forKey: key)
    }
    
    func clearAll() throws {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
    }
}
