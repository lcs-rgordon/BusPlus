//
//  Bus.swift
//  Bus
//
//  Created by Russell Gordon on 2021-08-03.
//

import Foundation

// MARK: - BusElement
struct Bus: Codable, Identifiable, Equatable {
    let id: Int
    let name, location, destination: String
    let passengers, fuel: Int
    let image: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
