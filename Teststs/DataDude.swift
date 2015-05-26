//
//  DataDude.swift
//  Teststs
//
//  Created by Sami Purmonen on 26/05/15.
//  Copyright (c) 2015 Sami Purmonen. All rights reserved.
//

import UIKit



public struct Company {
    public let name: String
    public let description: String
    
    public var image: UIImage {
        let name2 = name.stringByReplacingOccurrencesOfString(" ", withString: "-", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil).lowercaseString
        return UIImage(named: "\(name2)-logo.png") ?? UIImage(named: "abb-logo.png")!
    }
}

public struct ArmadaEvent {
    public let title: String
    public let summary: String
//    public let location: String
//    public let startDate: NSDate
//    public let endDate: NSDate
}

public class DataDude {
    public func companiesFromJson(json: AnyObject) -> [Company] {
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> Company? in
            if let name = json["name"] as? String,
                let description = json["description"] as? String {
                    return Company(name: name, description: description)
            }
            return nil
            } ?? [])
    }
    
    public func eventsFromJson(json: AnyObject) -> [ArmadaEvent] {
        return Array.removeNils((json as? [[String: AnyObject]])?.map { json -> ArmadaEvent? in
            if let title = json["title"] as? String,
                let summary = json["summary"] as? String {
                    return ArmadaEvent(title: title, summary: summary)
            }
            return nil
            } ?? [])
    }
    
    func companiesFromServer() -> [Company]? {
        let companyUrl = "http://armada.nu/api/companies.json"
        if let data = NSData(contentsOfURL: NSURL(string: companyUrl)!, options: nil, error: nil),
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                return companiesFromJson(json)
        }
        return nil
    }
    
    
}

extension Array {
    static func removeNils(array: [T?]) -> [T] {
        return array.filter { $0 != nil }.map { $0! }
    }
}