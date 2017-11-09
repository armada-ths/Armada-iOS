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
    
    let putURLString = "http://gotham.armada.nu/api/questions?student_id="
    let getURLString = "http://gotham.armada.nu/api/matching_result?student_id="
    
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
            if val {
                if key == "thesis"          { self.looking_for.append(1) }
                if key == "part-time job"   { self.looking_for.append(2) }
                if key == "trainee"         { self.looking_for.append(3) }
                if key == "summer job"      { self.looking_for.append(4) }
            }
        }
        // continents
        for (key, val) in matchData.worldBool{
            if val {
                if key == "africa"   { self.continents.append(1) }
                if key == "asia"     { self.continents.append(2) }
                if key == "oceania"  { self.continents.append(3) }
                if key == "europe"   { self.continents.append(4) }
                if key == "americaN" { self.continents.append(5) }
                if key == "ameicaS"  { self.continents.append(6) }
            }
        }
        // regions
        for (key, val) in matchData.swedenBool{
            if val {
                self.regions.append(matchData.swedenIntKey[key]!)
            }
        }
        // questions
        // grader
        let grader_id = 1 // get grader id in some way
        var grader = ["id": grader_id, "answer": matchData.smileyInt]
        // slider
        let slider_id = 2 // get slider id in some way
        var slider = ["id": slider_id, "answer": ["min": CGFloat(matchData.sliderValues["minTrue"]!), "max": CGFloat(matchData.sliderValues["maxTrue"]!)]] as [String : Any]
//        var slider = ["id": slider_id, "answer": ["min": 1, "max": 5]] as [String : Any]
        self.questions = [grader, slider]
        
        var areas = Array<Int>()
        // get the selected area ids in some way
        for (key, val) in matchData.subAreas {
            if val["select"] as! Bool == true {
                areas.append(Int(key)!)
                print(val)
            }
        }
//        print(areas)
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
    
    func putAnswer(student_id: String,  finished: @escaping ((_ isSuccess: Bool) -> Void)) {
        let toPost = buildForPut()
        let url = URL(string: putURLString + student_id)
        var request = URLRequest(url: url!)
        request.httpMethod = "put"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: toPost, options: .prettyPrinted) // pass dictionary to nsdata
            let theJSONText = try String(data: request.httpBody!,
                                     encoding: .ascii)
            print("request.httpBody \(theJSONText)")
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let response = response {
                print("data \(data)")
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
    
    func getStudentID() -> String {
        let defaults = UserDefaults.standard
        if let uuid = defaults.value(forKey: "uuid") {
            print("uuid: \(uuid)")
            return uuid as! String
        } else {
            let uuid = UUID().uuidString
            defaults.set(uuid, forKey: "uuid")
            print("created a uuid: \(uuid)")
            return uuid
        }
    }
    
    func getResult(student_id: String, finished: @escaping ((_ isSuccess: Bool,_ newMatchInstance: matchDataClass) -> Void)) {
        let url = URL(string: getURLString + student_id)
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
                        print(match?.matchResult)
                        finished(true, match!)
                        
                    } else {
                        finished(false, matchDataClass())
                    }
                    
                }
                
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
