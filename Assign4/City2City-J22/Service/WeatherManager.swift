//
//  WeatherManager.swift
//  City2City-J22
//
//  Created by mac on 1/31/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

/* Singleton
 single instance of an object in the life span of the life span of an app
 Final - does NOT allow inheritance
 Static Shared Instance - Forces everyone to go through the shared instance
 Private Init - no one else can make an instance
 */

//1).
final class WeatherManager {
    
    
    //2).
    static let shared = WeatherManager()
    //3).
    private init() {}
    
    
    func getWeather(for city: City, completion: @escaping (Weather?) -> Void) {
        
        //get url for end point
        guard let url = WeatherAPI(city).getUrl else {
            completion(nil)
            return
        }
        
        //API Request
        //data tasks start in a suspended state
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                completion(nil)
                print(error.localizedDescription)
                return
            }
            
            if let data = dat {
                
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    if let jsonDict = response,
                        let weather = Weather(jsonDict) {
                        completion(weather)
                    } else {
                        completion(nil)
                        return
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
            }
            
        } .resume()
        
        
    }
    
    
}
