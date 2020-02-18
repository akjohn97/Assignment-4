//
//  WeatherAPI.swift
//  City2City-J22
//
//  Created by mac on 1/31/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation


struct WeatherAPI {
    
    var city: City!
    let base = "https://api.openweathermap.org/data/2.5/weather?"
    let key = "&units=imperial&APPID=7cdcd7f9a8620c069b7159b27a5f7a34"
    
    init(_ city: City) {
        self.city = city
    }
    
    var getUrl: URL? {
        return URL(string: base + "lat=\(city.latitude)&lon=\(city.longitude)" + key)
    }
    
}
