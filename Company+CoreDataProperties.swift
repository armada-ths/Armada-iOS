//
//  Company+CoreDataProperties.swift
//  Teststs
//
//  Created by Sami Purmonen on 27/08/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Company {
    @NSManaged var name: String
    @NSManaged var primaryWorkField: String
    @NSManaged var companyDescription: String
    @NSManaged var website: String
    @NSManaged var facebook: String
    @NSManaged var linkedin: String
    @NSManaged var twitter: String
    @NSManaged var locationDescription: String
    @NSManaged var locationUrl: String
    @NSManaged var employeesSweden: Int
    @NSManaged var employeesWorld: Int
    @NSManaged var contactName: String
    @NSManaged var contactEmail: String
    @NSManaged var contactPhone: String
    @NSManaged var countries: Int
    @NSManaged var workFields: Set<WorkField>
    @NSManaged var jobTypes: Set<JobType>
    @NSManaged var continents: Set<Continent>
    @NSManaged var companyValues: Set<CompanyValue>
    @NSManaged var programmes: Set<Programme>
    @NSManaged var workWays: Set<WorkWay>
    @NSManaged var isStartup: Bool
    @NSManaged var hasClimateCompensated: Bool
    @NSManaged var likesEquality: Bool
    @NSManaged var likesEnvironment: Bool
    @NSManaged var adUrl: String
    @NSManaged var logoUrl: String
    
}
