//
//  PokemonDetail.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 05/03/2021.
//

import Foundation
// Used for presenting to the user at detail module view. Created from CORE DATA objects.
@objc class PokemonDetail:NSObject,Decodable {
    @objc var id:Int = 0
    @objc var height:Int = 0
    @objc var weight:Int = 0
    
    @objc var name:String?
    @objc var defaultImage:Data?
    var isCaptured:Bool? = false
    
    @objc var types:[Types]?
    @objc class Types:NSObject,Decodable {
        @objc var type:[String:String]?
    }
    
    @objc var sprites:PokemonSprites?
    @objc class PokemonSprites:NSObject,Decodable {
        // URLs to each pokemon sprites.
        @objc var back_female:String?
        @objc var back_shiny_female:String?
        @objc var back_default:String?
        @objc var front_female:String?
        @objc var front_shiny_female:String?
        @objc var back_shiny:String?
        @objc var front_default:String?
        @objc var front_shiny:String?
    }
    
    @objc var stats:[Stat]?
    @objc class Stat:NSObject,Decodable {
        @objc var base_stat:Int = 0
        @objc var stat:[String:String]?
    }
    
    @objc func isThisPokemonCaptured()-> NSNumber {
        return  NSNumber.init(booleanLiteral: isCaptured!)
    }
}






