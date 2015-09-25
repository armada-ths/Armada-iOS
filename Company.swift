//
//  ManagedCompany.swift
//  Teststs
//
//  Created by Sami Purmonen on 27/08/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Company: NSManagedObject {
    
    class func companyFromJson(json: AnyObject, managedObjectContext: NSManagedObjectContext) -> Company? {
        
        if let name = json["name"] as? String where !name.isEmpty,
            

            
            let workFields = json["work_fields"] as? [[String:AnyObject]],
            let programmes = json["programmes"] as? [[String:AnyObject]],
            let jobTypes = json["job_types"] as? [[String:AnyObject]],
            let continents = json["continents"] as? [[String:AnyObject]],
            //            let image = UIImage(named: name),
            let companyValues = json["company_values"] as? [[String:AnyObject]],
            let workWays = json["ways_of_working"] as? [[String:AnyObject]] {
                let website = json["website_url"] as? String ?? ""
                
                let countries = json["countries"] as? Int ?? 0
                let locationUrl = json["map_url"] as? String ?? ""
                let employeesSweden = json["employees_sweden"] as? Int ?? 0
                let employeesWorld = json["employees_world"] as? Int ?? 0
                let company = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: managedObjectContext) as! Company
                let description = json["description"] as? String ?? ""
                let keywords = json["keywords"] as? String ?? ""
                let contactName = json["contact_name"] as? String ?? ""
                let contactEmail = json["contact_email"] as? String ?? ""
                let contactPhone = json["contact_number"] as? String ?? ""
                let isStartup = json["startup_exhibitor"] as? Bool ?? false
                let likesEquality = json["diversity_exhibitor"] as? Bool ?? false
                let likesEnvironment = json["green_room_exhibitor"] as? Bool ?? false
                let hasClimateCompensated = json["has_climate_compensated"] as? Bool ?? false
                let locationDescription = json["location"] as? String ?? ""
                let facebook = json["facebook_url"] as? String ?? ""
                let linkedin = json["linkedin_url"] as? String ?? ""
                let twitter = json["twitter_url"] as? String ?? ""
                
                let adUrl = json["ad_url"] as? String ?? ""
                let logoUrl = json["logo_url"] as? String ?? ""
                
                company.name = name
                company.companyDescription = description
                company.website = website
                company.facebook = facebook
                company.linkedin = linkedin
                company.twitter = twitter
                company.employeesSweden = employeesSweden
                company.employeesWorld = employeesWorld
                company.locationDescription = locationDescription
                company.locationUrl = locationUrl
                company.contactName = contactName
                company.contactEmail = contactEmail
                company.contactPhone = contactPhone
                company.countries = countries
                company.isStartup = isStartup
                company.likesEquality = likesEquality
                company.likesEnvironment = likesEnvironment
                company.hasClimateCompensated = hasClimateCompensated
                company.logoUrl = logoUrl
                company.adUrl = adUrl
                company.keywords = keywords
                company.primaryWorkField = keywords
                
                _ = {
                    let fetchRequest = NSFetchRequest()
                    let entityName = "WorkField"
                    fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.executeFetchRequest(fetchRequest) as! [WorkField])
                    let workFields = Array.removeNils(workFields.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                    for workField in workFields {
                        let managedObject = existingObjects.filter({ $0.workField == workField }).first ?? NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! WorkField
                        managedObject.workField = workField
                        existingObjects.insert(managedObject)
                        company.workFields.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest()
                    let entityName = "JobType"
                    fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.executeFetchRequest(fetchRequest) as! [JobType])
                    let jobTypes = Array.removeNils(jobTypes.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                    for jobType in jobTypes {
                        let managedObject = existingObjects.filter({ $0.jobType == jobType }).first ?? NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! JobType
                        managedObject.jobType = jobType
                        existingObjects.insert(managedObject)
                        company.jobTypes.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest()
                    let entityName = "Continent"
                    fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Continent])
                    let continents = Array.removeNils(continents.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                    for continent in continents {
                        let managedObject = existingObjects.filter({ $0.continent == continent }).first ?? NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! Continent
                        managedObject.continent = continent
                        existingObjects.insert(managedObject)
                        company.continents.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest()
                    let entityName = "CompanyValue"
                    fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.executeFetchRequest(fetchRequest) as! [CompanyValue])
                    let companyValues = Array.removeNils(companyValues.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                    for companyValue in companyValues {
                        let managedObject = existingObjects.filter({ $0.companyValue == companyValue }).first ?? NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! CompanyValue
                        managedObject.companyValue = companyValue
                        existingObjects.insert(managedObject)
                        company.companyValues.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest()
                    let entityName = "Programme"
                    fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Programme])
                    let programmes = Array.removeNils(programmes.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                    for programme in programmes {
                        let managedObject = existingObjects.filter({ $0.programme == programme }).first ?? NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! Programme
                        managedObject.programme = programme
                        existingObjects.insert(managedObject)
                        company.programmes.insert(managedObject)
                    }
                    }()
                
                
                _ = {
                    let fetchRequest = NSFetchRequest()
                    let entityName = "WorkWay"
                    fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.executeFetchRequest(fetchRequest) as! [WorkWay])
                    let workWays = Array.removeNils(workWays.map{($0["name"] as? String)?.componentsSeparatedByString(" | ").last})
                    for workWay in workWays {
                        let managedObject = existingObjects.filter({ $0.workWay == workWay }).first ?? NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext) as! WorkWay
                        managedObject.workWay = workWay
                        existingObjects.insert(managedObject)
                        company.workWays.insert(managedObject)
                    }
                    }()
                
                return company
        } else {
            print("Failed to parse company")
        }
        
        return nil
    }
    
    public var imageName: String {
        var imageName = name
        imageName = imageName.stringByReplacingOccurrencesOfString("[^A-Za-z]+", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch)
        imageName = imageName.stringByReplacingOccurrencesOfString("( ab$)|(^ab )", withString: " ", options: [NSStringCompareOptions.RegularExpressionSearch, NSStringCompareOptions.CaseInsensitiveSearch])
        imageName = imageName.stringByReplacingOccurrencesOfString("(international|group|consulting|partner|foods|technology|technologies|financial|industrial|technique|services|systems|swedish|defence|materiel|administration|sweden|healthcare|manufacturing|advisory)", withString: "", options: [NSStringCompareOptions.RegularExpressionSearch, NSStringCompareOptions.CaseInsensitiveSearch])
        imageName = imageName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return imageName
    }
    
    public var image: UIImage? {
        return UIImage(named: imageName)
    }
    
    public var map: UIImage {
        if let url = NSURL(string: "http://www.armada.nu" + self.locationUrl),
            let data = NSData(contentsOfURL: url),
            let image = UIImage(data: data){
                return image
        }
        return UIImage()
    }
    
    var shortName: String {
        return ([" sverige", " ab", " sweden"].reduce(name) {
            $0.stringByReplacingOccurrencesOfString($1, withString: "", options: .CaseInsensitiveSearch)
            }).stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch)
    }
}

public func ==(x: Company, y: Company) -> Bool {
    return x.name == y.name
}
