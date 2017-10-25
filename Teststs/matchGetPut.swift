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
    
    let urlString = "http://ais2.armada.nu/api/student_profile?student_id="
    var matchResult = Dictionary<String, Any>()
    
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
        // REMEMBER TO DOUBLE CHECK ORDER WITH BACKEND
        var idx = 0
        for (_, val) in matchData.lookingBool{
            if val {
                self.looking_for.append(idx)
            }
            idx += 1
        }
        // regions
        // REMEMBER TO DOUBLE CHECK ORDER WITH BACKEND
        idx = 0
        for (_, val) in matchData.swedenBool{
            if val {
                self.regions.append(idx)
            }
            idx += 1
        }
        // continents
        // REMEMBER TO DOUBLE CHECK ORDER WITH BACKEND
        idx = 0
        for (_, val) in matchData.worldBool{
            if val {
                self.continents.append(idx)
            }
            idx += 1
        }
        // questions
        // grader
        let grader_id = 1 // get grader id in some way
        var grader = ["id": grader_id, "answer": matchData.smileyInt]
        // slider
        let slider_id = 2 // get slider id in some way
        var slider = ["id": slider_id, "answer": ["min": matchData.teamSizeMin, "max": matchData.teamSizeMax]] as [String : Any]
        self.questions = [grader, slider]
        
        // areas
        // get the selected area ids in some way
        var areas = [0, 1, 2, 3, 4]
        self.areas = areas
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
    
    func buildForPut() -> JSON {
        var toPost = ["looking_for": self.looking_for,
                      "regions":     self.regions,
                      "continents":  self.continents,
                      "questions":   self.questions,
                      "areas":       self.areas] as [String : Any]
        let json = JSON(toPost)
        return json
    }
    
    func put(student_id: Int) {
        let url = "http://ais2.armada."
    }
    
    func getStudentID() -> Int {
        
        return 0
    }
    
    func get(student_id: Int) -> Dictionary<String, Any>{
        let url = URL(string: urlString + String(student_id))
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
        }
        task.resume()
        
        //{"company_id": Int, "percent": Double, "3array": ["string1", "string2", "string3"], }
        
        // parse json to result
        
        var result = Dictionary<String, Any>()
        
        return result
    }
    
    
}
