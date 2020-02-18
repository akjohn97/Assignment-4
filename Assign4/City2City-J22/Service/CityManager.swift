//
//  CityManager.swift
//  City2City-J22
//
//  Created by mac on 1/28/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import CoreData

struct CityManager {
    
    
    //give us ability to save/modify Core Entities
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //place where all the core entities are stored
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "City2City_J22")
        container.loadPersistentStores { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    //MARK: Core - Getters
    static func load() -> [City] {
        
        let fetchRequest = NSFetchRequest<CoreCity>(entityName: "CoreCity")
        var cities = [City]()
        
        do {
            let coreCities = try context.fetch(fetchRequest)
            coreCities.forEach({
                if let city = City(core: $0) {
                    cities.append(city)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
        cities.reverse()
        var duplicates = [City]()
        for values in cities{
            if !duplicates.contains(values){
                duplicates.append(values)
            }
        }
        cities = duplicates
        let arraySlice = cities.prefix(10)
        cities = Array(arraySlice)
        return cities
    }
    
    
    //MARK: Core - Setters
    static func save(_ city: City) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreCity", in: context)!
        let coreCity = CoreCity(entity: entity , insertInto: context)
        coreCity.name = city.name
        coreCity.lat = city.latitude
        coreCity.long = city.longitude
        coreCity.state = city.state
        coreCity.population = city.population
        
        saveContext() //if you don't save, it doesn't persist
        
        print("Saved City to Core: \(city.name), \(city.state)")
    }
    

    //MARK: Core - Helper
    static func remove(_ city: City) {
        //fetch request to retrieve objects from core data
        let fetchRequest = NSFetchRequest<CoreCity>(entityName: "CoreCity")
        //predicate to narrow the search for core objects
        let namePredicate = NSPredicate(format: "name==%@", city.name)
        let statePredicate = NSPredicate(format: "state==%@", city.state)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, statePredicate])
        fetchRequest.predicate = compoundPredicate
        do {
            //use the fetch request to get back cities matching the predicate
            let coreCities = try context.fetch(fetchRequest)
            if let core = coreCities.first {
                context.delete(core) //delete the core data object
                print("Deleted City from Core: \(city.name), \(city.state)")
            }
            saveContext()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    static func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    //MARK: Get Cities
    
    static func getCities(completion: @escaping ([City]) -> Void ) {
        //convert path into url
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        //use GCD to go to background thread
        DispatchQueue.global().async {
            var cities = [City]() //container
            do {
                //get data from url path
                let data = try Data(contentsOf: url)
                //serialize data into data strucuture
                let response = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                for dict in response {
                    if let city = City(dict: dict) {
                        cities.append(city)
                    }
                }
              
                //pass all cities into completion
                completion(cities)
                print("Loaded Core Cities: \(cities.count)")
            } catch {
                print("Couldn't Get Cities: \(error.localizedDescription)")
            }
        }
    }
    
}
