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
    
    let putURLString = "http://ais2.armada.nu/api/student_profile?student_id="
    let getURLString = "http://ais2.armada.nu/api/matching_result?student_id="
    
    var matchResult = Array<Dictionary<String, Any>>()
    
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
    
    func buildForPut() -> Dictionary<String, Any> {
        var toPost = ["looking_for": self.looking_for,
                      "regions":     self.regions,
                      "continents":  self.continents,
                      "questions":   self.questions,
                      "areas":       self.areas] as [String : Any]
        return toPost
    }
    
    func putAnswer(student_id: Int) {
        let toPost = buildForPut()
        let dict = ["nickname": toPost]
        let url = URL(string: putURLString + String(student_id))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "put"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) // pass dictionary to nsdata
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(response)
        }
        task.resume()
    }
    
    func getStudentID() -> Int {
        return 0
    }
    
    func getResult(student_id: Int){
        let url = URL(string: getURLString + String(student_id))
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            do {
                if let data = data {
                    //[{"company_id": Int, "percent": Double, "3array": ["string1", "string2", "string3"], }, ...]
                    let response = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<Dictionary<String, Any>>
                    self.matchResult = response
                } else {
                    // Data is nil.
                }
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
