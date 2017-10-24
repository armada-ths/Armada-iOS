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
    var questions = Dictionary<String, Any>()
        // "grading": Array<Int>
        // "slider": Dictionary<String,Int>
    var areas = Array<Int>()

    init(){}
    
    func buildForPut(student_id: Int, looking_for: Array<Int>, regions: Array<Int>, continents: Array<Int>, questions: Dictionary<String, Any>, areas:Array<Int>) -> JSON {
        return JSON.null
    }
    
    func put(student_id: Int, json:JSON) {
        
    }
    
    func get(student_id: Int) -> Dictionary<String, Any>{
        //{"company_id": Int, "percent": Double, "3array": ["string1", "string2", "string3"], }
        
        // parse json to result
        
        var result = Dictionary<String, Any>()
        
        return result
    }
    
    
}
