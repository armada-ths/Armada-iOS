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

open class Company: NSManagedObject {
    
    class func companyFromJson(_ json: AnyObject, managedObjectContext: NSManagedObjectContext) -> Company? {
        
        if let name = json["name"] as? String , !name.isEmpty,
            

            
            let workFields = json["work_fields"] as? [[String:AnyObject]],
            let programmes = json["programs"] as? [[String:AnyObject]],
            let jobTypes = json["job_types"] as? [[String:AnyObject]],
            let continents = json["continents"] as? [[String:AnyObject]],
            //            let image = UIImage(named: name),
            let companyValues = json["values"] as? [[String:AnyObject]] {
                let website = json["website_url"] as? String ?? ""
                
                let countries = json["countries"] as? Int ?? 0
                let locationUrl = json["map_url"] as? String ?? ""// TODO: Checka den
                let videoUrl = json["video_url"] as? String ?? ""// TODO: Checka den
                let employeesSweden = json["employees_sweden"] as? Int ?? 0
                let employeesWorld = json["employees_world"] as? Int ?? 0
                let description = json["description"] as? String ?? ""
                let keywords = json["keywords"] as? String ?? ""// ???
                let contactName = json["contact_name"] as? String ?? ""// ???
                let contactEmail = json["contact_email"] as? String ?? ""// ???
                let contactPhone = json["contact_number"] as? String ?? ""// ???
                let isStartup = json["startup_exhibitor"] as? Bool ?? false// TODO: Checka den
                let likesEquality = json["diversity"] as? Bool ?? false
                let likesEnvironment = json["green_room_exhibitor"] as? Bool ?? false// ???
                let hasClimateCompensated = json["sustainability"] as? Bool ?? false// TODO: Checka den
                let locationDescription = json["location"] as? String ?? ""// TODO: Sannorligt rätt
                let facebook = json["facebook_url"] as? String ?? ""
                let linkedin = json["linkedin_url"] as? String ?? ""
                let twitter = json["twitter_url"] as? String ?? ""
                
                let adUrl = json["ad_url"] as? String ?? ""
                let logoUrl = json["logo_url"] as? String ?? ""
            
            
                let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: managedObjectContext) as! Company
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
                company.videoUrl = videoUrl
            
            _ = {
                    let fetchRequest = NSFetchRequest<WorkField>()
                    let entityName = "WorkField"
                    fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.fetch(fetchRequest) )
                    let workFields = Array.removeNils(workFields.map{($0["name"] as? String)?.components(separatedBy: " | ").last})
                    for workField in workFields {
                        let managedObject = existingObjects.filter({ $0.workField == workField }).first ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! WorkField
                        managedObject.workField = workField
                        existingObjects.insert(managedObject)
                        company.workFields.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest<JobType>()
                    let entityName = "JobType"
                    fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.fetch(fetchRequest))
                    let jobTypes = Array.removeNils(jobTypes.map{($0["name"] as? String)?.components(separatedBy: " | ").last})
                    for jobType in jobTypes {
                        let managedObject = existingObjects.filter({ $0.jobType == jobType }).first ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! JobType
                        managedObject.jobType = jobType
                        existingObjects.insert(managedObject)
                        company.jobTypes.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest<Continent>()
                    let entityName = "Continent"
                    fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.fetch(fetchRequest))
                    let continents = Array.removeNils(continents.map{($0["name"] as? String)?.components(separatedBy: " | ").last})
                    for continent in continents {
                        let managedObject = existingObjects.filter({ $0.continent == continent }).first ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! Continent
                        managedObject.continent = continent
                        existingObjects.insert(managedObject)
                        company.continents.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest<CompanyValue>()
                    let entityName = "CompanyValue"
                    fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.fetch(fetchRequest))
                    let companyValues = Array.removeNils(companyValues.map{($0["name"] as? String)?.components(separatedBy: " | ").last})
                    for companyValue in companyValues {
                        let managedObject = existingObjects.filter({ $0.companyValue == companyValue }).first ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! CompanyValue
                        managedObject.companyValue = companyValue
                        existingObjects.insert(managedObject)
                        company.companyValues.insert(managedObject)
                    }
                    }()
                
                _ = {
                    let fetchRequest = NSFetchRequest<Programme>()
                    let entityName = "Programme"
                    fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
                    var existingObjects = Set(try! managedObjectContext.fetch(fetchRequest))
                    let programmes = Array.removeNils(programmes.map{($0["name"] as? String)?.components(separatedBy: " | ").last})
                    for programme in programmes {
                        let managedObject = existingObjects.filter({ $0.programme == programme }).first ?? NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext) as! Programme
                        managedObject.programme = programme
                        existingObjects.insert(managedObject)
                        company.programmes.insert(managedObject)
                    }
                    }()
                
                return company
        } else {
            print("Failed to parse company")
        }
        
        return nil
    }
    
    open var imageName: String {
        var imageName = name
        imageName = imageName.replacingOccurrences(of: "[^A-Za-z]+", with: " ", options: NSString.CompareOptions.regularExpression)
        imageName = imageName.replacingOccurrences(of: "( ab$)|(^ab )", with: " ", options: [NSString.CompareOptions.regularExpression, NSString.CompareOptions.caseInsensitive])
        imageName = imageName.replacingOccurrences(of: "(international|group|consulting|partner|foods|technology|technologies|financial|industrial|technique|services|systems|swedish|defence|materiel|administration|sweden|healthcare|manufacturing|advisory)", with: "", options: [NSString.CompareOptions.regularExpression, NSString.CompareOptions.caseInsensitive])
        imageName = imageName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return imageName
    }
    
    open var image: UIImage? {
        return UIImage(named: imageName)
    }
    
    open var map: UIImage {
        if let url = URL(string: "http://www.armada.nu" + self.locationUrl),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data){
                return image
        }
        return UIImage()
    }
    
    var shortName: String {
        return ([" sverige", " ab", " sweden"].reduce(name) {
            $0.replacingOccurrences(of: $1, with: "", options: .caseInsensitive)
            }).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
}

public func ==(x: Company, y: Company) -> Bool {
    return x.name == y.name
}
