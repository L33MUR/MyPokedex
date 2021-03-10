//
//  LocalDataManager.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 28/02/2021.
import UIKit
import CoreData

//Manage all interacions with CoreDataStack. CRUD logic (Create-Read-Update-Delete)
class LocalDataManager {
    static let shared = LocalDataManager()
    var coreDataStack = CoreDataStack.shared
    var managedObjectContext:NSManagedObjectContext!
    
    
    //default init
    init() {
        DispatchQueue.global().async {
            self.managedObjectContext = self.coreDataStack.mainContext
        }
    }
    
    //init for testing with custom coreDataStack
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}


// MARK: -  CRUD Logic -
extension LocalDataManager {
    func createInstances<T>(objects:[T],
                           creator:((T,NSManagedObjectContext)->NSManagedObject),
                           completion:@escaping (Result<[NSManagedObject], Error>)->Void){
        ///Receives a closure with steps for creating a NSManagedObject from a generic object.
        ///Example:
        ///let creator = { (object:Object, context:NSManagedObjectContext)->Void in
        ///    let instance = T(context: context)
        ///    instance.name = object.name
        ///    instance.data = object.name }
        var newInstances:[NSManagedObject]  = []
        for object in objects{
            newInstances.append(creator(object, managedObjectContext))
        }
        self.updateChanges() { (result) in
            switch result{
                case .success():
                    completion(.success((newInstances)))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func readInstances(fetchRequest:NSFetchRequest<NSFetchRequestResult>, completion:@escaping (Result<[Any], Error>)->Void){
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            completion(.success(objects))
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateChanges(completion:@escaping (Result<Void, Error>)->Void){
        coreDataStack.saveContext() { (result) in
            switch result{
                case .success():
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    
    func deleteInstances(instances:[NSManagedObject], completion:@escaping (Result<Void, Error>)->Void){
        for instance in instances{
            managedObjectContext.delete(instance)
        }
        self.updateChanges() { (result) in
            switch result{
                case .success():
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

// MARK: - User Defaults -
extension LocalDataManager {
    private enum UserDefaultKeys:String {
        case firstDataLoadedStatus //== False, means tha the App should requets Data from API at launch.(Usually only once time)
    }
    var firsDataLoadedStatus:Bool {
        get{
            if let status = UserDefaults.standard.value(forKey: UserDefaultKeys.firstDataLoadedStatus.rawValue) as? Bool{
                return status
            }else{
                return  false
            }
        }
        set{
            UserDefaults.standard.set(newValue,forKey: UserDefaultKeys.firstDataLoadedStatus.rawValue)
        }
    }
}
