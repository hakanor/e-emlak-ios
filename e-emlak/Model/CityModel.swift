//
//  City.swift
//  e-emlak
//
//  Created by Hakan Or on 24.10.2022.
//

import Foundation

// MARK: - City
struct City: Codable {
    let name: String
    let towns: [Town]
}

// MARK: - Town
struct Town: Codable {
    let name: String
    let districts: [District]
}

// MARK: - District
struct District: Codable {
    let name: String
    let quarters: [Quarter]
}

// MARK: - Quarter
struct Quarter: Codable {
    let name: String
}
