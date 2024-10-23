//
//  StorageServiceProtocol.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

protocol StorageServiceProtocol {
    func save<T: Codable>( _ item: T, for key: String) throws
    func fetch<T: Codable>(for key: String) throws -> T?
    func delete(for key: String) throws
    func clearAll() throws
}
