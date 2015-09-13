//
//  WorkWay+CoreDataProperties.swift
//  Teststs
//
//  Created by Sami Purmonen on 13/09/15.
//  Copyright © 2015 Sami Purmonen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WorkWay {

    @NSManaged var workWay: String
    @NSManaged var companies: NSSet

}
