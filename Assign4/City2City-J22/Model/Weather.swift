//
//  Weather.swift
//  City2City-J22
//
//  Created by mac on 1/31/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

struct Weather {
    let description: String
    let temp: Double
    let windSpeed: Double
    let feelsLike: Double
    
    init?(_ dict: [String:Any]) {
        guard let mainDict = dict["main"] as? [String:Any],
            let temp = mainDict["temp"] as? Double,
            let feels = mainDict["feels_like"] as? Double,
            let weatherDict = dict["weather"] as? [[String:Any]],
            let descrip = weatherDict.first!["description"] as? String,
            let windDict = dict["wind"] as? [String:Double],
            let speed = windDict["speed"]  else {return nil}
        
        
        self.temp = temp
        self.feelsLike = feels
        self.description = descrip
        self.windSpeed = speed
    }
}
