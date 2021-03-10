//
//  TestCoreDataStack.swift
//  MyPokedexTests
//
//  Created by Pedro  Rey Simons on 08/03/2021.
//

import XCTest
import CoreData
import MyPokedex


class TestCoreDataStack: CoreDataStack {
    // CoreDataStack subclass that uses an in-memory store rather than the current SQLite store. Because an in-memory store isn’t persisted to disk, when the test finishes executing, the in-memory store releases its data, avoiding persist corrupt data while testing.
    
    override init() {
        super.init()
        
        // Creates an in-memory persistent store.
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        // Creates an NSPersistentContainer instance, passing in the modelName and NSManageObjectModel stored in the CoreDataStack.
        let container = NSPersistentContainer(
            name: CoreDataStack.modelName,
            managedObjectModel: CoreDataStack.model)
        
        // Assigns the in-memory persistent store to the container.
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Overrides the storeContainer in CoreDataStack.
        storeContainer = container
    }
}

