//
//  Bus.swift
//  Bus
//
//  Created by Russell Gordon on 2021-08-03.
//

import Foundation

// MARK: - BusElement
struct Bus: Codable, Identifiable {
    let id: Int
    let name, location, destination: String
    let passengers, fuel: Int
    let image: String
}
