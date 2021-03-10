//
//  CoreDataStack.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 01/03/2021.
//

import Foundation
import CoreData


//Custom core data stack,
open class CoreDataStack {
    //MARK:- Properties -
    public static let shared:CoreDataStack = CoreDataStack()
    public static let modelName = Constants.Entities.modelName
    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    //MARK:- Methods -
    public init() {}
    
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }
    
    public func saveContext(completion:@escaping (Result<Void, Error>)->Void) {
        saveContext(mainContext) { (result) in
            switch result{
                case .success():
                    completion(.success((())))
                    break
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    public func saveContext(_ context: NSManagedObjectContext, completion:@escaping (Result<Void, Error>)->Void) {
        if context != mainContext {
            saveDerivedContext(context) { (result) in
                switch result{
                    case .success():
                        completion(.success((())))
                        break
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
            return
        }
        
        context.perform {
            do {
                try context.save()
                completion(.success((())))
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
                completion(.failure(error))
            }
        }
    }
    
    public func saveDerivedContext(_ context: NSManagedObjectContext,completion:@escaping (Result<Void, Error>)->Void) {
        context.perform {
            do {
                try context.save()
                completion(.success(()))
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
                completion(.failure(error))
            }
            
            self.saveContext(self.mainContext) { (result) in
                switch result{
                    case .success():
                        completion(.success((())))
                        break
                    case .failure(let error):
                        completion(.failure(error))
                }
                
            }
        }
    }
}

