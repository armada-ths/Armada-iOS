//
//  matchGetPut.swift
//  Armada
//
//  Created by Ola Roos on 2017-10-24.
//  Copyright © 2017 Sami Purmonen. All rights reserved.
//
import SwiftyJSON
import Foundation

class matchGetPut {
    
    var looking_for = Array<Int>()
    var regions = Array<Int>()
    var continents = Array<Int>()
    var questions = Array<Any>()
        // "grading": Array<Int>
        // "slider": Int
    var areas = Array<Int>()
    init(){}
    
    init(matchData: matchDataClass){
        
        // looking_for
        var idx = 0
        for (_, val) in matchData.lookingBool{
            if val {
                self.looking_for.append(idx)
            }
            idx += 1
        }

        // regions
        
        // continents
        
        // questions – grader
        // get grader id in some way
        let grader_id = 0
        var grader = ["id": grader_id, "answer": matchData.smileyInt]
        // questions – slider
        // get slider id in some way
//        var slider = ["id": slider_id, "answer": ["min": matchData.min, "max" matchData.max]
        var slider = [String: Any]()
        
        self.questions = [grader, slider]
        // areas
    }
    
    func test(){
        var toPost = ["looking_for": self.looking_for,
                      "regions":     self.regions,
                      "continents":  self.continents,
                      "questions":   self.questions,
                      "areas":       self.areas] as [String : Any]
        
        let json = JSON(toPost)
        print(json)
    }
    
    func buildForPut(looking_for: Array<Int>, regions: Array<Int>, continents: Array<Int>, questions: Array<Any>, areas:Array<Int>) -> JSON {
        
        var toPost = ["looking_for": looking_for,
                      "regions":     regions,
                      "continents":  continents,
                      "questions":   questions,
                      "areas":       areas] as [String : Any]
        
        let json = JSON(toPost)
        print(json.rawValue)
        
        return JSON.null
    }
    
    func put(student_id: Int, json:JSON) {
        
    }
    
    func getStudentID() -> Int {
        return 0
    }
    
    func get(student_id: Int) -> Dictionary<String, Any>{
        //{"company_id": Int, "percent": Double, "3array": ["string1", "string2", "string3"], }
        
        // parse json to result
        
        var result = Dictionary<String, Any>()
        
        return result
    }
    
    
}
