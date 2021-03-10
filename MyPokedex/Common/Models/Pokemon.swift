//
//  ResourcesAPI.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 28/02/2021.
//

import Foundation
import CoreData

//MARK:- API Resources -

//API answer with the list of pokemon resources availables.
struct BaseResource:Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let resources: [NamedResource]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case resources = "results"
    }
}

//To manage API answer with each of pokemon resource data.
class NamedResource:Decodable {
    var name:String?
    var url:String?
    lazy var data:PokemonData? = PokemonData()
    
    class PokemonData:Decodable {
        var jsonData:Data?
        var id:Int16? = 0
        var sprites:PokemonSprites?
        lazy var defaultImage:DefaultImage = DefaultImage()
        
        class DefaultImage:Decodable{
            var url:String?
            var data:Data?
        }
    }
    
    struct PokemonSprites:Decodable {
        // URLs to each pokemon sprites.
        var back_female:String?
        var back_shiny_female:String?
        var back_default:String?
        var front_female:String?
        var front_shiny_female:String?
        var back_shiny:String?
        var front_default:String?
        var front_shiny:String?
    }
    
    
    //Creates entity from NamedResource
    class func pokemonEntityInstantiator(resource:NamedResource,context:NSManagedObjectContext)->PokemonEntity{
        let newInstance = PokemonEntity(context: context)
        newInstance.id = resource.data?.id ?? Int16.max
        newInstance.image = resource.data?.defaultImage.data
        newInstance.jsonData = resource.data?.jsonData
        newInstance.resourceName = resource.name
        newInstance.resourceUrl = resource.url
        newInstance.isCaptured = false
        
        return newInstance
    }
    
}




//MARK:- Pokemon -
//Object to be stored in coreData
class Pokemon:Codable {
    var id:Int16 = 0
    var image:Data = Data()
    var resourceName:String = ""
    var resourceUrl:String = ""
    var jsonData:Data = Data() //Data representation for Pokemon resource JSON
    var isCaptured:Bool = false
}





