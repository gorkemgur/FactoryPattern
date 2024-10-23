//
//  StorageError.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

enum StorageError: Error {
    case saveError(String)
    case fetchError(String)
    case deleteError(String)
    case decodingError(String)
    case encodingError(String)
    case invalidData
}
