//
//  matchGetPut.swift
//  Armada
//
//  Created by Ola Roos on 2017-10-24.
//  Copyright © 2017 Ola Roos. All rights reserved.
//
import SwiftyJSON
import Foundation

struct matchResultObject {
    var reasons: Array<String>
    let percent: Double
    let exhibitor: Int
    
    init(reasons: Array<String>, percent: Double, exhibitor: Int) {
        self.reasons = reasons
        self.percent = percent
        self.exhibitor = exhibitor
    }
}

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
        for (key, val) in matchData.lookingBool{
            if key == "thesis"          { self.looking_for.append(1) }
            if key == "part-time job"   { self.looking_for.append(2) }
            if key == "trainee"         { self.looking_for.append(3) }
            if key == "summer job"      { self.looking_for.append(4) }
        }
        // continents
        for (key, val) in matchData.worldBool{
            if key == "africa"   { self.continents.append(1) }
            if key == "asia"     { self.continents.append(2) }
            if key == "oceania"  { self.continents.append(3) }
            if key == "europe"   { self.continents.append(4) }
            if key == "americaN" { self.continents.append(5) }
            if key == "ameicaS"  { self.continents.append(6) }
        }
        // regions
        // REMEMBER TO DOUBLE CHECK ORDER WITH BACKEND
        var idx = 0
        for (_, val) in matchData.swedenBool{
            if val {
                self.regions.append(idx)
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
    
    func buildForPut() -> Dictionary<String, Any> {
        var toPost = ["looking_for": self.looking_for,
                      "regions":     self.regions,
                      "continents":  self.continents,
                      "questions":   self.questions,
                      "areas":       self.areas] as [String : Any]
        return toPost
    }
    
    func putAnswer(student_id: Int,  finished: @escaping ((_ isSuccess: Bool) -> Void)) {
        let toPost = buildForPut()
        print("toPost \(toPost)")
        let dict = ["nickname": toPost]
        let url = URL(string: putURLString + String(student_id))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "put"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) // pass dictionary to nsdata
            print("request.httpBody \(request.httpBody)")
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let response = response {
                print(response.url)
                print(response)
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200{
                    finished(true)
                } else {
                    finished(false)
                }
            }
        }
        task.resume()
    }
    
    func getStudentID() -> Int {
        return 0
    }
    
    func getResult(student_id: Int, finished: @escaping ((_ isSuccess: Bool) -> Void)) {
        let url = URL(string: getURLString + String(student_id))
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            do {
                if let response = response {
                    if let data = data {
                        let response = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Array<Dictionary<String, AnyObject>>
                        var resultArray = Array<Dictionary<String, Any>>()
                        for item in response{
                            var reasons = Array<String>()
                            if let array = item["reasons"] as? Array<String> {
                                for string in array {
                                    reasons.append(string)
                                }
                            }
                            let percent = item["percent"] as! Double
                            let exhibitor = item["exhibitor"] as! Int
                            resultArray.append(["reasons": reasons, "percent": percent, "exhibitor": exhibitor] as Dictionary<String, Any>)
                        }
                        let match = matchDataClass().load()
                        match?.matchResultStatus = 1
                        match?.matchResult = resultArray
                        match?.save()
                        finished(true)
                    } else {
                        finished(false)
                    }
                    
                }
                
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
