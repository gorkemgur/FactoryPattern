//
//  User.swift
//  factorySample
//
//  Created by Görkem Gür on 23.10.2024.
//

import Foundation

struct User: Codable, Equatable {
    let id: String
    let name: String
    let email: String
    let isActive: Bool
}
