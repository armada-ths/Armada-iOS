//
//  matchDataClass.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-09.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
import SwiftyJSON

class matchDataClass: NSObject{
    
    /* ------ elements ------ */
    var currentview:Int
    
    var lookingBool:[String: Bool]
    var swedenBool:[String: Bool]
    var worldBool:[String: Bool]
    var europeBool:[String: Bool]
    
    var travel:Double
    
    var teamSize:Int
    var teamSizeMax:Int
    var teamSizeMin:Int
    
    var currentInterest:Int
    var interestBools:[String: Bool]
    var interestList:Array<String>
    var interestInts:Array<Int>
    
    var time:String
    /* ---------------------- */
    
    //    init(currentview: Int,
    //         lookingBool:[String: Bool],
    //         swedenBool:[String: Bool],
    //         worldBool:[String: Bool],
    //         europeBool:[String: Bool],
    //         travel:Double,
    //         teamSize:Int,
    //         teamSizeMax:Int,
    //         teamSizeMin:Int,
    //         currentInterest:Int,
    //         interestBools:[String: Bool],
    //         interestList:Array<String>,
    //         interestInts:Array<Int>){
    //
    //        self.currentview = currentview
    //        self.lookingBool = lookingBool
    //        self.swedenBool = swedenBool
    //        self.worldBool = worldBool
    //        self.europeBool = europeBool
    //        self.travel = travel
    //        self.teamSize = teamSize
    //        self.teamSizeMax = teamSizeMax
    //        self.teamSizeMin = teamSizeMin
    //        self.currentInterest = currentInterest
    //        self.interestBools = interestBools
    //        self.interestList = interestList
    //        self.interestInts = interestInts
    //    }
    
    override init() {
        currentview = 0
        
        lookingBool = [
            "part-time job": false,
            "summer job":    false,
            "thesis":        false,
            "trainee":       false
        ]
        
        swedenBool = [
            "area1": false,
            "area2": false,
            "area3": false
        ]
        
        worldBool = [
            "europe":   false,
            "asia":     false,
            "americaN": false,
            "americaS": false,
            "australia":false
        ]
        
        europeBool = [
            "germany":  false,
            "italy":    false,
            "france":   false
        ]
        
        travel = 0.0
        
        teamSize = 0
        teamSizeMax = 10
        teamSizeMin = 0
        
        currentInterest = 0
        interestBools = [
            "it":               false,
            "chemistry":        false,
            "finance":          false,
            "infrastructure":   false,
            "management":       false,
            "innovation":       false
        ]
        interestList = []
        interestInts = Array(repeatElement(0, count: interestBools.count))
        
        time = String(describing: Date())
    }
    
    init(_ json: JSON){
        
        self.travel =          json["travel"].doubleValue
        
        self.currentview =     json["currentview"].intValue
        self.teamSize =        json["teamSize"].intValue
        self.teamSizeMax =     json["teamSizeMax"].intValue
        self.teamSizeMin =     json["teamSizeMin"].intValue
        self.currentInterest = json["currentInterest"].intValue
        
        var lookingBool:[String: Bool] = [:]
        var swedenBool:[String: Bool] = [:]
        var worldBool:[String: Bool] = [:]
        var europeBool:[String: Bool] = [:]
        var interestBools:[String: Bool] = [:]
        
        var interestList:Array<String> = Array<String>()
        
        var interestInts:Array<Int> = Array<Int>()
        
        for (key, val):(String, JSON) in json["lookingBool"] {
            lookingBool[key] = val.boolValue
        }
        self.lookingBool = lookingBool
        for (key, val):(String, JSON) in json["swedenBool"] {
            swedenBool[key] = val.boolValue
        }
        self.swedenBool = swedenBool
        for (key, val):(String, JSON) in json["worldBool"] {
            worldBool[key] = val.boolValue
        }
        self.worldBool = worldBool
        for (key, val):(String, JSON) in json["europeBool"] {
            europeBool[key] = val.boolValue
        }
        self.europeBool = europeBool
        for (key, val):(String, JSON) in json["interestBools"] {
            interestBools[key] = val.boolValue
        }
        self.interestBools = interestBools
        
        for (_, val):(String, JSON) in json["interestList"] {
            interestList.append(val.stringValue)
        }
        self.interestList = interestList
        
        for (_, val):(String, JSON) in json["interestInts"] {
            interestInts.append(val.intValue)
        }
        self.interestInts = interestInts
        self.time = json["time"].stringValue
    }
    
    func toJSON() -> JSON {
        
        var jsonArray = [String:JSON]()
        let mirrored_object = Mirror(reflecting: self)
        for (index, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String! {
                let jsonObject = JSON(attr.value)
                jsonArray[property_name] = jsonObject
                //print("Attr \(index): \(property_name) = \(attr.value)")
            }
        }
        let finalJSON = JSON(jsonArray)
        
        return finalJSON
    }
    
    func save() {
        let defaults = UserDefaults.standard
        self.time = String(describing: Date())
        defaults.set(self.toJSON().rawString()!, forKey: "json")
    }
    
    func load() -> matchDataClass? {
        let defaults = UserDefaults.standard
        if let string = defaults.value(forKey: "json") as? String {
            let parsedjson = JSON.init(parseJSON: string)
            return matchDataClass(parsedjson)
        } else {
            return nil
        }
    }
}
