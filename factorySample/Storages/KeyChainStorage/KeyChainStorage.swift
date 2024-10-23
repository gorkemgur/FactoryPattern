//
//  KeyChainStorage.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

final class KeychainStorage: StorageServiceProtocol {
    func save<T: Codable>(_ item: T, for key: String) throws {
        do {
            let data = try JSONEncoder().encode(item)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status == errSecSuccess else {
                throw StorageError.saveError("Keychain save failed with status: \(status)")
            }
        } catch {
            throw StorageError.saveError("Keychain save failed: \(error.localizedDescription)")
        }
    }
    
    func fetch<T: Codable>(for key: String) throws -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw StorageError.decodingError("Keychain decode failed: \(error.localizedDescription)")
        }
    }
    
    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw StorageError.deleteError("Keychain delete failed with status: \(status)")
        }
    }
    
    func clearAll() throws {
        let secItemClasses = [kSecClassGenericPassword]
        
        for itemClass in secItemClasses {
            let query: [String: Any] = [kSecClass as String: itemClass]
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw StorageError.deleteError("Keychain clear failed with status: \(status)")
            }
        }
    }
}
