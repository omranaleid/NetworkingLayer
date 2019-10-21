//
//  City.swift
//  prsnls-ios
//
//  Created by Omran on 2019-10-03.
//  Copyright © 2019 Guarana Technologies Inc. All rights reserved.
//

import Foundation

struct City: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "city"
        case id
    }
}

struct CityResponse: Codable {
    var message: String
    var data: [City]
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
    }
}
