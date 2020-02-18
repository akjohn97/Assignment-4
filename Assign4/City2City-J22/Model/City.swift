//
//  City.swift
//  City2City-J22
//
//  Created by mac on 1/28/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct City: Hashable {
    let name: String
    let latitude: Double
    let longitude: Double
    let population: String
    let state: String
    
    init?(dict: [String:Any]) {
        guard
            let name = dict["city"] as? String,
            let state = dict["state"] as? String,
            let long = dict["longitude"] as? Double,
            let lat = dict["latitude"] as? Double,
            let pop = dict["population"] as? String else { return nil }
        
        self.name = name
        self.latitude = lat
        self.longitude = long
        self.population = pop
        self.state = state
    }
    
    init?(core: CoreCity) {
        guard let name = core.name,
            let state = core.state,
            let pop = core.population else { return nil}
        
        self.name = name
        self.state = state
        self.population = pop
        self.latitude = core.lat
        self.longitude = core.long
    }
    
    
}
