//
//  matchDataClass.swift
//  matchingExp
//
//  Created by Ola Roos on 2017-10-09.
//  Copyright © 2017 Ola Roos. All rights reserved.
//

import UIKit
import SwiftyJSON

//struct matchResultObject {
//    var reasons: Array<String>
//    let percent: Double
//    let exhibitor: Int
//
//    init(reasons: Array<String>, percent: Double, exhibitor: Int) {
//        self.reasons = reasons
//        self.percent = percent
//        self.exhibitor = exhibitor
//    }
//}

class matchDataClass: NSObject{
    
    /* view-descriptions */
    var grader: Dictionary<String, Any>
    var slider: Dictionary<String, Any>
    var areas: Array<Dictionary<String, Any>>
    /* to be saved */
    var mainAreas: Dictionary<String, Bool>
    var subAreas: Dictionary<String, Dictionary<String, Any>>
    var sliderValues: Dictionary<String, Double>
    var swedenIntKey: Dictionary<String, Int>
    /* (-1) filling out form, (0) waiting for result, (1) got match result */
    var matchResultStatus: Int
    var matchResult: Array<Dictionary<String, Any>>
    
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
        subAreas = Dictionary<String, Dictionary<String, Any>>()
        sliderValues = Dictionary<String, Double>()
        swedenIntKey = Dictionary<String, Int>()
        matchResult = Array<Dictionary<String, Any>>()
        matchResultStatus = -1
        smileyInt = 666
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
        
        self.areaListDynamic = Array<String>()
        self.interrestList = Dictionary<String, Array<Dictionary<String, Any>>>()
        
        /* properties ABOVE not loaded from defaults YET! */
        
        self.mainAreas = Dictionary<String, Bool>()
        for (key, val) in json["mainAreas"] {
            self.mainAreas[String(key)] = val.boolValue
        }
        self.subAreas = Dictionary<String, Dictionary<String, Any>>()
        for item in json["subAreas"] {
            let subareaObj = ["id": item.1["id"].int!, "field": item.1["field"].stringValue, "parent": item.1["parent"].stringValue, "select": item.1["select"].boolValue] as [String : Any]
            self.subAreas[item.1["id"].stringValue] = subareaObj
        }
        self.sliderValues = Dictionary<String, Double>()
        self.sliderValues["max"] = json["sliderValues"]["max"].doubleValue
        self.sliderValues["min"] = json["sliderValues"]["min"].doubleValue
        self.sliderValues["maxTrue"] = json["sliderValues"]["maxTrue"].doubleValue
        self.sliderValues["minTrue"] = json["sliderValues"]["minTrue"].doubleValue
        self.areas = Array<Dictionary<String, Any>>()
        for (_, val) in json["areas"] {
            self.areas.append(["id": val["id"].int!, "field": val["field"].string!, "area": val["area"].string!])
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
        
        self.smileyInt = json["smileyInt"].intValue
        self.matchResult = Array<Dictionary<String, Any>>()
        
        for item in json["matchResult"] {
            var reasons = Array<String>()
            for json in item.1["reasons"] {
                reasons.append(json.1.stringValue)
            }
            self.matchResult.append(["reasons": reasons, "percent": item.1["percent"].doubleValue, "exhibitor": item.1["exhibitor"].intValue] as Dictionary<String, Any>)
        }
        
        self.matchResultStatus = json["matchResultStatus"].intValue
        self.travel =          json["travel"].doubleValue
        
        self.currentview =     json["currentview"].intValue
        self.teamSize =        json["teamSize"].intValue
        self.teamSizeMax =     json["teamSizeMax"].intValue
        self.teamSizeMin =     json["teamSizeMin"].intValue
        self.currentArea =     json["currentArea"].intValue

        self.worldIntrest = json["worldIntrest"].boolValue
        self.lookingBool = [:]
        for (key, val):(String, JSON) in json["lookingBool"] {
            self.lookingBool[key] = val.boolValue
        }
        self.swedenBool = [:]
        for (key, val):(String, JSON) in json["swedenBool"] {
            self.swedenBool[key] = val.boolValue
        }
        self.swedenIntKey = Dictionary<String, Int>()
        for (key, val):(String, JSON) in json["swedenIntKey"] {
            self.swedenIntKey[key] = val.intValue
        }
        self.worldBool = [:]
        for (key, val):(String, JSON) in json["worldBool"] {
            self.worldBool[key] = val.boolValue
        }
        self.areaBools = [:]
        for (key, val):(String, JSON) in json["areaBools"] {
            self.areaBools[key] = val.boolValue
        }
        self.areaList = Array<String>()
        for (_, val):(String, JSON) in json["areaList"] {
            self.areaList.append(val.stringValue)
        }
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
    func createAreasForced() {
        // kolla gamla listan
        // spara dem som finns i nya listan
        var tmpMainAreas = Dictionary<String, Bool>()
        var tmpSubAreas = Dictionary<String, Dictionary<String, Any>>()
        for item in self.areas {
            if self.mainAreas[item["area"] as! String] != nil {
                tmpMainAreas[item["area"] as! String] = self.mainAreas[item["area"] as! String]
                
            } else {
                tmpMainAreas[item["area"] as! String] = false
            }
            
            var subareaObj:[String: Any]
            if self.subAreas[String(item["id"] as! Int)] != nil {
                tmpSubAreas[String(item["id"] as! Int)] = self.subAreas[String(item["id"] as! Int)]!
            } else {
                tmpSubAreas[String(item["id"] as! Int)] = ["id": item["id"] as! Int, "field": item["field"] as! String, "parent": item["area"] as! String, "select": false] as [String : Any]
            }
        }
        self.subAreas = tmpSubAreas
        self.mainAreas = tmpMainAreas
//        print(self.mainAreas)
        //print(self.subAreas)
//        print(self.mainAreas)
//        print("loading in new match data")
//        print(self.subAreas)
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
