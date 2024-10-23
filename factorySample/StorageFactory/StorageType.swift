//
//  StorageType.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

enum StorageType {
    case userDefaults
    case coreData(modelName: String)
    case keychain
}
