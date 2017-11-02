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
import SwiftyJSON

open class Company: NSManagedObject {
    fileprivate let applicationDocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    
    class func companyFromJson(_ json: AnyObject, managedObjectContext: NSManagedObjectContext) -> Company? {
        
        if let name = json["company"] as? String , !name.isEmpty{
            

            var website = json["company_website"] as? String ?? ""
            if (!website.starts(with: "http://") && !website.starts(with:"https://") && website != ""){
                website = "http://" + website;
            }
            let id = json["id"] as? Int ?? 0
            let workFields = json["work_fields"] as? [[String:AnyObject]]
            let programmes = json["programs"] as? [[String:AnyObject]]
            let jobTypes = json["job_types"] as? [[String:AnyObject]]
            let continents = json["continents"] as? [[String:AnyObject]]
            let image = UIImage(named: name)
            let companyValues = json["values"] as? [[String:AnyObject]]
                let countries = json["countries"] as? Int ?? 0
                let locationUrl = json["map_location_url"] as? String ?? ""// TODO: finns inte än?
                let videoUrl = json["video_url"] as? String ?? ""// TODO: finns inte än?
                let employeesSweden = json["employees_sweden"] as? Int ?? 0
                let employeesWorld = json["employees_world"] as? Int ?? 0
                let description = json["about"] as? String ?? ""
                let booth = json["booth_number"] as? Int ?? 0
                let keywords = json["keywords"] as? String ?? ""// TODO: Bort?
                let contactName = json["contact_name"] as? String ?? ""// TODO: Bort?
                let contactEmail = json["contact_email"] as? String ?? ""// TODO: Bort?
                let contactPhone = json["phone_numbe"] as? String ?? ""// TODO: Bort?
                let isStartup = json["startup"] as? Bool ?? false// TODO: Finns inte med än?
                let likesEquality = json["diversity"] as? Bool ?? false
                let likesEnvironment = json["sustainability"] as? Bool ?? false
                let locationDescription = json["exhibitor_location"] as? String ?? ""// TODO: Sannorligt rätt men finns inte än
                let facebook = json["facebook_url"] as? String ?? ""
                let linkedin = json["linkedin_url"] as? String ?? ""
                let twitter = json["twitter_url"] as? String ?? ""
                let primaryWorkField = (json["main_work_field"] as? [String:AnyObject])?["name"] as? String ?? ""
            
                let adUrl = json["ad_url"] as? String ?? ""
                let logoUrl = json["logo_url"] as? String ?? ""
                var hostName: String
                var hostEmail: String
                var hostId: Int
            if((json["hosts"] as! NSArray).count > 0){
                let hostJson =  JSON((json["hosts"] as! NSArray)[0])
                let host = hostJson.dictionaryObject
                hostEmail = host!["email"] as! String
                hostId = host!["id"] as! Int
                hostName = host!["name"] as! String
            }
            else{
                hostEmail = ""
                hostId = -1
                hostName = ""
            }
            

            
                let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: managedObjectContext) as! Company
                company.name = name
                company.id = id
                company.booth = booth
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
                company.logoUrl = logoUrl
                company.adUrl = adUrl
                company.keywords = keywords
                company.primaryWorkField = primaryWorkField
                company.videoUrl = videoUrl
                company.hostName = hostName
                company.hostId = hostId
                company.hostEmail = hostEmail

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
            let imageDirectory = applicationDocumentsDirectory.appendingPathComponent("logos")
//            for company in companies {
//                print(company.name)
//                print(company.imageName)
//                try! FileManager.default.createDirectory(at: imageDirectory, withIntermediateDirectories: true, attributes: nil)
//                if let url = URL(string: company.logoUrl) {
//                    url.getData() {
//                        if case .success(let data) = $0 {
//                            try? data.write(to: imageDirectory.appendingPathComponent(company.imageName + ".png"), options: [.atomic])
//                        }
//                    }
//                }
//            }
//        }
        let image = imageDirectory.appendingPathComponent(imageName + ".png")
        return UIImage(contentsOfFile: image.path)
    }
    
    open var localImage: UIImage? {
        return UIImage(named: imageName)
    }
    
//    open var map: UIImage {
//        if let url = URL(string: "http://www.armada.nu" + self.locationUrl),
//            let data = try? Data(contentsOf: url),
//            let image = UIImage(data: data){
//                return image
//        }
//        return UIImage()
//    }
    
    var shortName: String {
        return ([" sverige", " ab", " sweden"].reduce(name) {
            $0.replacingOccurrences(of: $1, with: "", options: .caseInsensitive)
            }).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
}

public func ==(x: Company, y: Company) -> Bool {
    return x.name == y.name
}
