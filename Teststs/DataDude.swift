//
//  DataDude.swift
//  Teststs
//
//  Created by Sami Purmonen on 26/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit

var allCompanyNames = [
    "ABB",
    "Accenture",
    "Academic Work",
    "Adecco",
    "Capgemini",
    "Ericsson",
    "Volvo",
    "Combitech",
    "Cybercom",
    "Arla Foods",
    "Astra Zeneca",
    ].sorted { $0 < $1 }

public struct Company: Equatable {
    
    init!(json: [String: AnyObject]){
        
        if let name = json["name"] as? String,
            let description = json["description"] as? String,
            let website = json["website_url"] as? String,
            let facebook = json["facebook_url"] as? String,
            let linkedin = json["linkedin_url"] as? String,
            let twitter = json["twitter_url"] as? String,
            let locationDescription = json["fair_location_description"] as? String,
            let locationUrl = json["map_url"] as? String,
            let employeesSweeden = json["employees_sweden"] as? Int,
            let employeesWorld = json["employees_world"] as? Int,
            let contactName = json["contact_name"] as? String,
            let contactEmail = json["contact_email"] as? String,
            let contactPhone = json["contact_number"] as? String,
            
            let workFields = json["work_fields"] as? [[String:AnyObject]],
            let programmes = json["programmes"] as? [[String:AnyObject]],
            let jobTypes = json["job_types"] as? [[String:AnyObject]],
            let continents = json["continents"] as? [[String:AnyObject]],
            let companyValues = json["company_values"] as? [[String:AnyObject]]{
                
                self.name = name
                self.description = description
                self.website = website
                self.facebook=facebook
                self.linkedin = linkedin
                self.twitter=twitter
                self.employeesSweeden = employeesSweeden
                self.employeesWorld = employeesWorld
                self.locationDescription = locationDescription
                self.locationUrl = locationUrl
                self.contactName = contactName
                self.contactEmail = contactEmail
                self.contactPhone = contactPhone
                
                self.programmes = Array.removeNils(programmes.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                self.jobTypes = Array.removeNils(jobTypes.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                self.companyValues = Array.removeNils(companyValues.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                self.continents = Array.removeNils(continents.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                self.workFields = Array.removeNils(workFields.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                
        }else {
            return nil
        }
        
    }
    
    
    public let name: String
    public let description: String
    public let website: String
    public let facebook: String
    public let linkedin: String
    public let twitter: String
    public let locationDescription: String
    public let locationUrl: String
    public let workFields: [String]
    public let programmes: [String]
    public let jobTypes: [String]
    public let companyValues: [String]
    public let continents: [String]
    public let employeesSweeden: Int
    public let employeesWorld: Int
    public let contactName: String
    public let contactEmail: String
    public let contactPhone: String
    
    public var image: UIImage? {
        return UIImage(named: name.stringByReplacingOccurrencesOfString("[^A-Za-z]+", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch))
    }
    public var map: UIImage {
        if let url = NSURL(string: "http://www.armada.nu"+self.locationUrl),
            let data = NSData(contentsOfURL: url),
            let image = UIImage(data: data){
                return image
        }
        return UIImage()
    }
    
    // Pretty code for shortening uninteresting stuff like AB in names
    var shortName: String {
        return (reduce([" sverige", " ab", " sweden"], name) {
        $0.stringByReplacingOccurrencesOfString($1, withString: "", options: .CaseInsensitiveSearch)
        }).stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch)
    }
    
    func asyncLocationImage(callback: UIImage? -> Void) {
        NSOperationQueue().addOperationWithBlock {
            if let url = NSURL(string: "http://www.armada.nu"+self.locationUrl),
                let data = NSData(contentsOfURL: url),
                let image = UIImage(data: data){
                    callback(image)
            } else {
                callback(nil)
            }
        }
    }
}

public func ==(x: Company, y: Company) -> Bool {
    return x.name == y.name
}

public struct ArmadaEvent {
    public let title: String
    public let summary: String
    public let location: String
    public let startDate: NSDate
    public let endDate: NSDate
}

public struct News {
    public let title: String
    public let content: String
    public let publishedDate: NSDate
}


let DataDude = _DataDude()
public class _DataDude {
    
    private init() {}
    
    func dateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        let b = string.componentsSeparatedByString(":")
        return dateFormatter.dateFromString(":".join(b[0..<b.count-1]) + b[b.count-1])!
    }
    
    
    var companies = [Company]()
    public func companiesFromJson(json: AnyObject) -> [Company] {
        let companies = Array.removeNils((json as? [[String: AnyObject]])?.map { json -> Company? in
            return Company(json: json)
            } ?? [])
        self.companies = companies.sorted { $0.name < $1.name }
        
        
        println("Companies not knowing what they want: \(self.companies.filter({ $0.programmes.isEmpty }).count)")
        return companies.sorted { $0.name < $1.name }
    }
    
    public func allCompanyValues(companies:[Company]) -> Set<String>{
        return Set(companies.map({$0.jobTypes}).reduce([String](), combine: +))
    }
    
    
    var jobs: [String] {
        return Array(Set(companies.map({$0.jobTypes}).reduce([String](), combine: +)))
    }
    
    var programmes: [String] {
        return Array(Set(companies.map({$0.programmes}).reduce([String](), combine: +))).sorted(<).filter({$0.rangeOfString(" in ") != nil})
    }
    
    public func eventsFromJson(json: AnyObject) -> [ArmadaEvent] {
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> ArmadaEvent? in
            if let title = json["title"] as? String,
                let summary = json["summary"] as? String,
                let location = json["location"] as? String,
                let startDateString = json["starts_at"] as? String,
                let endDateString = json["ends_at"] as? String {
                    return ArmadaEvent(title: title, summary: summary.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch, range: nil), location: location.isEmpty ? "Valhallavägen" : location, startDate: self.dateFromString(startDateString), endDate: self.dateFromString(endDateString))
            }
            return nil
            } ?? []).filter { $0.startDate.timeIntervalSince1970 >=  NSDate().timeIntervalSince1970 }
    }
    public func newsFromJson(json: AnyObject) -> [News] {
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> News? in
            if let title = json["title"] as? String,
                let content = json["content"] as? String,
                let date = json["date_published"] as? String{
                    return News(title: title, content: content, publishedDate: self.dateFromString(date))
            }
            return nil
            } ?? [])
    }
    
    func companiesFromServer() -> [Company]? {
        let companyUrl = "http://armada.nu/api/companies.json?include=relations"
        if let data = NSData(contentsOfURL: NSURL(string: companyUrl)!, options: nil, error: nil),
            let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                return companiesFromJson(json)
        }
        return nil
    }
    
    func eventsFromServer() -> [ArmadaEvent]? {
        let companyUrl = "http://armada.nu/api/events.json"
        if let data = NSData(contentsOfURL: NSURL(string: companyUrl)!, options: nil, error: nil),
            let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                return eventsFromJson(json)
        }
        return nil
    }
    
    func newsFromServer() -> [News]? {
        let companyUrl = "http://armada.nu/api/news.json"
        if let data = NSData(contentsOfURL: NSURL(string: companyUrl)!, options: nil, error: nil),
            let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                return newsFromJson(json)
        }
        return nil
    }
    
}

extension Array {
    static func removeNils(array: [T?]) -> [T] {
        return array.filter { $0 != nil }.map { $0! }
    }
}