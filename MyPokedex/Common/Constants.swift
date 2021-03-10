//
//  Constants.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 02/03/2021.
//

import Foundation

//String Constants.
@objc class Constants:NSObject {
    @objc static let objcPokeball = Images.pokeball
    
    struct Endpoints {
        static let baseURL = { () -> String in
            //TODO: Add setting for the user to change the limit. Paginate request.
            let limit:Int = 151 //Number of pokemons to get, max value comes in Api Answer (1118). By now just get 1st Generation.
            let offset:Int = 0 //Starting index of pokemon
            return "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        }
    }
    
    struct Entities {
        static let container = "MyPokedex"
        static let modelName = "MyPokedex"

        static let pokemonEntity = "PokemonEntity"
        
        struct pokemonAttributes {
            static let id = "id"
            static let image = "image"
            static let isCaptured = "isCaptured"
            static let jsonData = "jsonData"
            static let resourceName = "resourceName"
            static let resourceUrl = "resourceUrl"
        }
        
        struct sprites {
            static let back_female = "back_female"
            static let back_shiny_female = "back_shiny_female"
            static let back_default = "back_default"
            static let front_female = "front_female"
            static let front_shiny_female = "front_shiny_female"
            static let back_shiny = "back_shiny"
            static let front_default = "front_default"
            static let front_shiny = "front_shiny"
        }
    }
    
    struct Images {
        static let pokeball = "pokeball"
        static let myPokedex = "myPokedex"

    }
}
