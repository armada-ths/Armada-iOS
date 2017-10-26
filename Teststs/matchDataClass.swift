//
//  matchDataClass.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-09.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
import SwiftyJSON

struct AreaObject {
    
    var id: Int
    var field: String
    var parentArea: String
    var select: Bool
    
    init(id: Int, field: String, parent: String, select: Bool){
        self.id = id
        self.field = field
        self.parentArea = parent
        self.select = select
    }
}

class matchDataClass: NSObject{
    
    /* view-descriptions */
    var grader: Dictionary<String, Any>
    var slider: Dictionary<String, Any>
    var areas: Array<Dictionary<String, Any>>
    /* to be saved */
    var mainAreas: Dictionary<String, Bool>
    var subAreas: Dictionary<String, AreaObject>
    /* (-1) filling out form, (0) waiting for result, (1) got match result */
    var matchResultStatus: Int
    
    var currentview:Int
    var lookingBool:[String: Bool]
    var swedenBool:[String: Bool]
    var worldIntrest: Bool
    var worldBool:[String: Bool]
    var smileyInt:Int
    var travel:Double
    var teamSize:Int
    var teamSizeMax:Int
    var teamSizeMin:Int
    var currentArea:Int
    var areaBools:[String: Bool]
    var areaList:Array<String>
    var areaListDynamic:Array<String>
    var interrestList:Dictionary<String, Array<Dictionary<String, Any>>>
    var time:String
    
    override init() {

        grader = Dictionary<String, Any>()
        slider = Dictionary<String, Any>()
        areas = Array<Dictionary<String, Any>>()
        mainAreas = Dictionary<String, Bool>()
        subAreas = Dictionary<String, AreaObject>()
        matchResultStatus = -1
        smileyInt = 0
        currentview = 0
        lookingBool = [
            "part-time job": false,
            "summer job":    false,
            "thesis":        false,
            "trainee":       false
        ]
        swedenBool = [:]
        worldIntrest = false
        worldBool = [
            "europe":   false,
            "asia":     false,
            "americaN": false,
            "oceania":  false,
            "americaS":     false,
            "africa":   false
        ]
        travel = 0.0
        teamSize = 0
        teamSizeMax = 10
        teamSizeMin = 0
        currentArea = 0
        areaBools = [:]
        areaList = Array<String>()
        areaListDynamic = Array<String>()
        interrestList = Dictionary<String, Array<Dictionary<String, Any>>>()
        time = String(describing: Date())
    }
    
    init(_ json: JSON){
        
        self.mainAreas = Dictionary<String, Bool>()
        self.subAreas = Dictionary<String, AreaObject>()
        self.areaListDynamic = Array<String>()
        self.interrestList = Dictionary<String, Array<Dictionary<String, Any>>>()
        self.smileyInt = Int()
        /* properties ABOVE not loaded from defaults YET! */
        
        self.areas = Array<Dictionary<String, Any>>()
        for (_, val) in json["areas"] {
            self.areas.append(["id": val["id"].int, "field": val["field"].string, "area": val["area"].string])
        }
        self.slider = Dictionary<String, Any>()
        self.slider["step"] = json["slider"]["step"].int
        self.slider["min"] = json["slider"]["min"].int
        self.slider["max"] = json["slider"]["max"].int
        self.slider["question"] = json["slider"]["question"].string
        self.slider["type"] = json["slider"]["type"].string
        self.grader = Dictionary<String, Any>()
        self.grader["question"] = json["grader"]["question"].string
        self.grader["type"] = json["grader"]["type"].string
        self.grader["steps"] = json["grader"]["steps"].int
        
        self.matchResultStatus = json["matchResultStatus"].intValue
        self.travel =          json["travel"].doubleValue
        
        self.currentview =     json["currentview"].intValue
        self.teamSize =        json["teamSize"].intValue
        self.teamSizeMax =     json["teamSizeMax"].intValue
        self.teamSizeMin =     json["teamSizeMin"].intValue
        self.currentArea =     json["currentArea"].intValue
        
        var lookingBool:[String: Bool] = [:]
        var swedenBool:[String: Bool] = [:]
        var worldBool:[String: Bool] = [:]
        var areaBools:[String: Bool] = [:]
        var areaList:Array<String> = Array<String>()
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
        self.worldIntrest = json["worldIntrest"].boolValue
        self.worldBool = worldBool
        for (key, val):(String, JSON) in json["areaBools"] {
            areaBools[key] = val.boolValue
        }
        self.areaBools = areaBools
        for (_, val):(String, JSON) in json["areaList"] {
            areaList.append(val.stringValue)
        }
        self.areaList = areaList
        self.time = json["time"].stringValue
    }
    func toJSON() -> JSON {
        var jsonArray = [String:JSON]()
        let mirrored_object = Mirror(reflecting: self)
        for (_, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String! {
                let jsonObject = JSON(attr.value)
                jsonArray[property_name] = jsonObject
            }
        }
        let finalJSON = JSON(jsonArray)
        return finalJSON
    }
    func createAreas() {
        if self.mainAreas.count == 0 {
            for item in self.areas {
                // setup main areas
                self.mainAreas[item["area"] as! String] = false
                // setup sub areas
                let subareaObj = AreaObject(id: item["id"] as! Int, field: item["field"] as! String, parent: item["area"] as! String, select: false)
                self.subAreas[item["id"] as! String] = subareaObj
            }
        }
    }
    func save() {
        createAreas()
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
