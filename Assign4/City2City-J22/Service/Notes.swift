//
//  Notes.swift
//  City2City-J22
//
//  Created by mac on 1/29/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

/*
 GCD - Grand Central Dispatch - apple's lightweight api to handle multi-threading and going to and from the main thread
 sync - tasks are done sequentially
 async - tasks are done in the most optimized route regardless of when they are queued
 serialization - taking data and turning it into a custom object
 ------------
 
 Closures - Types: non-escaping (default), escaping
 closure - is a nameless function
 escaping - the closure has a separate life span than the function it resides in
 non-escaping - lives and dies with the function
 ------------
 
 Static - belongs to the object, NOT an instance (globally accessible)
 
 Higher Order Functions - Map, Filter, CompactMap, Sorted, Reduce
 - a function that has another function as one of its parameters or returns a function
 - MAP - iterates through each element in collection and performs a closure (set of instructions)
 - CompactMap - same thing as map except removes nil values
 - Filter - iterates through each element of collection and only keeps elements that pass the given check
 
 ------------
 
 Access Controls - Open, Public, Internal, Fileprivate, private
 Open - can be accessed outside of the module and CAN be modified
 Public - can be accessed outside of the module (app) but NOT modified
 Internal - default access control and can be accessed within the module
 FilePrivate - can only be accessed within the file regardless of declaration
 Private - can only be accessed within the declaration
 
 
 ---------------
 
 Core Data Stack
 
 NSManagedObjectContext - its context that all Core Entities are created/updated/saved
 NSManagedObject - Core Data entities represented by graphs (in data model)
 PersistentStoreCoordinator - handle how the container is saved
 PersitentContainer - where all of the entities are stored
 
 
 
 */
