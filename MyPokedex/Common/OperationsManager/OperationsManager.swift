//
//  LocalDataOperator.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 01/03/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator and edited by Pedro Rey Simons.
//

import Foundation
import CoreData

// MARK: - Custom errors
private enum OperatorCustomError: Error {
    // Create enum of custom errors
    case emptyResources
    case emptyPokemons
}

extension OperatorCustomError: LocalizedError {
    //Create extension of CustomError to handle localized description.
    fileprivate var errorDescription: String? {
        switch self {
            case .emptyResources:
                return NSLocalizedString("There aren't resources", comment: "")
            case .emptyPokemons:
                return NSLocalizedString("There aren't pokemons", comment: "")
        }
    }
}

//This class contains common complex operations to be used on several modules.
final class OperationsManager {
    var remoteDataManager = RemoteDataManager(session: URLSession(configuration: URLSessionConfiguration.default))
    let localDataManager = LocalDataManager.shared
    var baseResource:BaseResource?
    var resources:[NamedResource]?
}
 
// MARK: - Operation getAndSaveData -
/// Call API for data and override existing data on local data base
extension OperationsManager{
    public func getAndSaveData( completion:@escaping (Result<Void, Error>) -> Void){
        let op = OperationQueue()
        let gr = DispatchGroup()
            
        
        //Initial call to API for getting data to use in further requests
        let getBaseResourceOp = BlockOperation {
            gr.enter()
            self.getBaseResource { (result) in
                switch result{
                    case .success(let baseResource):
                        self.baseResource = baseResource
                        gr.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        op.cancelAllOperations()
                }
            }
            gr.wait()
        }
        
        
        //Call to API for getting JSON with info of each resource (Data formatted to be easily stored in Core Data)
        let getJsonDataOp = BlockOperation {
            gr.enter()
            self.getJsonData(resources: (self.baseResource?.resources)!, completion: {(result) in
                switch result{
                    case .success(_):
                        gr.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        op.cancelAllOperations()
                }
            })
            gr.wait()
        }
        
        
        //Decode JSON for each resource to get some properties and the sprites urls.
        let decodeJsonDataOp = BlockOperation {
            gr.enter()
            self.decodeJsonProperties(resources: (self.baseResource?.resources)!, completion: {(result) in
                switch result{
                    case .success(_):
                        gr.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        op.cancelAllOperations()
                }
            })
            gr.wait()
        }
        
        
        //Call to API for getting data of a default image for each resource, to be stored locally.
        let getImageDataOp = BlockOperation {
            gr.enter()
            self.getImageData(resources: (self.baseResource?.resources)!) { (result) in
                switch result{
                    case .success(_):
                        gr.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        op.cancelAllOperations()
                }
            }
            gr.wait()
        }
        

        //Read all existing CoreData Pokemon Entities
        var existingPokemons:[PokemonEntity] = []
        let readExistingPokemonsOp = BlockOperation {
            gr.enter()
            self.readExistingPokemons { (result) in
                switch result{
                    case .success(let objects):
                        existingPokemons = objects
                        gr.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        op.cancelAllOperations()
                }
            }
            gr.wait()
        }
        
        //Clean all CoreData Pokemon Entities before saving new instances.
        let deleteExistingPokemonsOp = BlockOperation {
            if existingPokemons.count > 0 {
                gr.enter()
                self.deleteExistingPokemons(objects: existingPokemons) { (result) in
                    switch result{
                        case .success(_):
                            gr.leave()
                        case .failure(let error):
                            completion(.failure(error))
                            op.cancelAllOperations()
                    }
                }
                gr.wait()
            }
        }
        
        //Creates new instances of PokemonEntity in CoreData
        let createNewPokemonsOp = BlockOperation {
            gr.enter()
            self.createPokemons { (result) in
                switch result{
                    case .success(_):
                        gr.leave()
                    case .failure(let error):
                        completion(.failure(error))
                        op.cancelAllOperations()
                }
            }
            gr.wait()
        }

        
        //Operation accomplished
        let finalOp = BlockOperation {
            completion(.success(()))
        }
        
        //Add dependencies to set an order based on DispatchGroup
        getJsonDataOp.addDependency(getBaseResourceOp)
        decodeJsonDataOp.addDependency(getJsonDataOp)
        getImageDataOp.addDependency(decodeJsonDataOp)
        
        readExistingPokemonsOp.addDependency(getImageDataOp)
        deleteExistingPokemonsOp.addDependency(readExistingPokemonsOp)
        createNewPokemonsOp.addDependency(deleteExistingPokemonsOp)
        finalOp.addDependency(createNewPokemonsOp)
                
        //Start operations
        op.addOperation(getBaseResourceOp)
        op.addOperation(getJsonDataOp)
        op.addOperation(decodeJsonDataOp)
        op.addOperation(getImageDataOp)
        
        op.addOperation(readExistingPokemonsOp)
        op.addOperation(deleteExistingPokemonsOp)
        op.addOperation(createNewPokemonsOp)
        op.addOperation(finalOp)
        
    }
    
    // MARK: - Remote -
    func getBaseResource(completion:@escaping (Result<BaseResource, Error>)->Void){
        remoteDataManager.fetchGenericJSONObject(endpoint: Constants.Endpoints.baseURL()) { (result:Result<BaseResource, Error>) in
            switch result{
                case .success(let resources):
                    if let _ = resources.resources{
                        completion(.success(resources))
                    }else{
                        completion(.failure(OperatorCustomError.emptyResources))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func getJsonData(resources:[NamedResource],completion:@escaping (Result<[NamedResource], Error>)->Void){
        let gr = DispatchGroup()
        for resource in resources {
            if let endpoint = resource.url{
                gr.enter()
                remoteDataManager.fetchData(endpoint: endpoint, completion: { (result) in
                    switch result{
                        case .success(let (data,_)):
                            resource.data!.jsonData = data //resource.data is marked as optional for JSON Decodable compatibily, but it always exists.
                            gr.leave()
                        case .failure(let error):
                            print("getJsonData \(String(describing: resource.name)) FAIL: \(error.localizedDescription)")
                            print("Continue loading next pokemon data...")
                            gr.leave()
                    }
                })
            }
        }
        gr.wait()//Waits until every resource has been fetched
        completion(.success(resources))
    }
    
    func decodeJsonProperties(resources:[NamedResource],completion:@escaping (Result<[NamedResource], Error>)->Void){
        for resource in resources {
            if let jsonData = resource.data?.jsonData{
                do {
                    let JSONObject = try JSONDecoder().decode(NamedResource.PokemonData.self, from: jsonData)
                    resource.data!.sprites = JSONObject.sprites
                    resource.data!.id = JSONObject.id
                } catch  {
                    print("decodeJsonProperties \(String(describing: resource.name)) FAIL: \(error.localizedDescription)")
                    print("Continue loading next pokemon data...")
                    continue
                }
            }
        }
        completion(.success(resources))
    }
    
    func getImageData(resources:[NamedResource],completion:@escaping (Result<[NamedResource], Error>)->Void){
        let gr = DispatchGroup()
        for resource in resources {
            if let endpoint = resource.data?.sprites?.front_default{
                gr.enter()
                remoteDataManager.fetchData(endpoint: endpoint, completion: { (result) in
                    switch result{
                        case .success(let (data,_)):
                            resource.data!.defaultImage.data = data //resource.data is marked as optional for JSON Decodable compatibily, but it always exists.
                            gr.leave()
                        case .failure(let error):
                            print("getImageData \(String(describing: resource.name)) FAIL: \(error.localizedDescription)")
                            print("Continue loading next pokemon image...")
                            gr.leave()
                    }
                })
            }
        }
        gr.wait()//Waits until every resource has been fetched
        completion(.success(resources))
    }
    
    func readExistingPokemons(completion:@escaping (Result<[PokemonEntity], Error>)->Void) {
        let name:String = Constants.Entities.pokemonEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        localDataManager.readInstances(fetchRequest: fetchRequest) { (result) in
            switch result{
                case .success(let objects):
                    completion(.success(objects as![PokemonEntity]))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    // MARK: - Local -
    func deleteExistingPokemons(objects:[PokemonEntity],completion:@escaping (Result<Void, Error>)->Void){
        self.localDataManager.deleteInstances(instances: objects) { (result) in
            switch result{
                case .success():
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func createPokemons(completion:@escaping (Result<Void, Error>)->Void){
        guard var resources = self.baseResource?.resources else {
            completion(.failure(OperatorCustomError.emptyResources))
            return
        }
        resources.removeAll {$0.data?.id == 0} // ID == 0, means that there was some issue obtaning JSON data. Object is removed.
        if resources.count > 0 {
                localDataManager.createInstances(objects: resources, creator: NamedResource.pokemonEntityInstantiator) { (result) in
                    switch result{
                        case .success(_):
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
        } else {
            completion(.success(()))
        }
    }
}