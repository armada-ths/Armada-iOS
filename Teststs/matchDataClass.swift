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
    
    
    /* ---- view-descriptions ---- */
    var backendData:[String: Array<[String: Any]>]
    /* ---- data to save ---- */
    var currentview:Int
    
    var lookingBool:[String: Bool]
    var swedenBool:[String: Bool]
    var worldIntrest: Bool
    var worldBool:[String: Bool]
    
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
    /* ---------------------- */
    
    //    init(currentview: Int,
    //         lookingBool:[String: Bool],
    //         swedenBool:[String: Bool],
    //         worldBool:[String: Bool],
    //         travel:Double,
    //         teamSize:Int,
    //         teamSizeMax:Int,
    //         teamSizeMin:Int,
    //         currentArea:Int,
    //         areaBools:[String: Bool],
    //         areaList:Array<String>,{
    //
    //        self.currentview = currentview
    //        self.lookingBool = lookingBool
    //        self.swedenBool = swedenBool
    //        self.worldBool = worldBool
    //        self.travel = travel
    //        self.teamSize = teamSize
    //        self.teamSizeMax = teamSizeMax
    //        self.teamSizeMin = teamSizeMin
    //        self.currentArea = currentArea
    //        self.areaBools = areaBools
    //        self.areaList = areaList
    //    }
    
    override init() {
        currentview = 0
        
        backendData = Dictionary<String, Array<Dictionary<String, Any>>>()
        backendData["questions"] = [[
            "id": 1 as Any,
             "type": "slider" as Any,
             "question": "How big company would you like to work in?" as Any,
             "min": 5.0 as Any,
             "max": 1000.0 as Any,
             "logarithmic": true as Any,
             "units": "UNITS" as Any
            ],
            ["id": 2 as Any,
             "type": "grading" as Any,
             "question": "How happy are you today?" as Any,
             "count": 5 as Any]
        ]
        
        backendData["areas"] = [[
            "id": 1 as Any,
            "work_field": "loT" as Any,
            "area": "IT" as Any ],[
            "id": 2 as Any,
            "work_field": "Machine Learning" as Any,
            "area": "IT" as Any],[
            "id": 3 as Any,
            "work_field": "Real Estate" as Any,
            "area": "Finance" as Any],[
            "id": 4 as Any,
            "work_field": "Bookkeeping" as Any,
            "area": "Finance" as Any]
        ]
        
        lookingBool = [
            "part-time job": false,
            "summer job":    false,
            "thesis":        false,
            "trainee":       false
        ]
        
        swedenBool = [:]
        //     "area1": false,
        //     "area2": false,
        //     "area3": false,
        //     "area4": false,
        //     "area5": false,
        //     "area6": false,
        //     "area7": false,
        //     "area8": false
        // ]
        
        worldIntrest = false
        
        worldBool = [
            "europe":   false,
            "asia":     false,
            "americaN": false,
            "oceania": false,
            "americaS":  false,
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
        
        /* properties BELOW not saved in defaults YET! */
        self.backendData = Dictionary<String, Array<Dictionary<String, Any>>>()
        backendData["questions"] = [[
            "id": 1 as Any,
            "type": "slider" as Any,
            "question": "How big company would you like to work in?" as Any,
            "min": 5.0 as Any,
            "max": 1000.0 as Any,
            "logarithmic": true as Any,
            "units": "UNITS" as Any
            ],
                                    ["id": 2 as Any,
                                     "type": "grading" as Any,
                                     "question": "How happy are you today?" as Any,
                                     "count": 5 as Any]
        ]
        
        backendData["areas"] = [[
            "id": 1 as Any,
            "work_field": "loT" as Any,
            "area": "IT" as Any ],[
                "id": 2 as Any,
                "work_field": "Machine Learning" as Any,
                "area": "IT" as Any],[
                    "id": 3 as Any,
                    "work_field": "Real Estate" as Any,
                    "area": "Finance" as Any],[
                        "id": 4 as Any,
                        "work_field": "Bookkeeping" as Any,
                        "area": "Finance" as Any]
        ]
        
        /* properties ABOVE not saved in defaults YET! */
        
        self.travel =          json["travel"].doubleValue
        
        self.currentview =     json["currentview"].intValue
        self.teamSize =        json["teamSize"].intValue
        self.teamSizeMax =     json["teamSizeMax"].intValue
        self.teamSizeMin =     json["teamSizeMin"].intValue
        self.currentArea = json["currentArea"].intValue
        
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
        
        // NEED INITIALIZER
        self.areaListDynamic = Array<String>()
        self.interrestList = Dictionary<String, Array<Dictionary<String, Any>>>()
        
        self.time = json["time"].stringValue
    }
    
    func toJSON() -> JSON {
        
        var jsonArray = [String:JSON]()
        let mirrored_object = Mirror(reflecting: self)
        for (_, attr) in mirrored_object.children.enumerated() {
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
