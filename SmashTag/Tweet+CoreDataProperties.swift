//
//  Tweet+CoreDataProperties.swift
//  SmashTag
//
//  Created by Robert Dunbar on 28/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var posted: NSDate?
    @NSManaged var text: String?
    @NSManaged var unique: String?
    @NSManaged var search: SearchTerm?
    @NSManaged var tweeter: TwitterUser?

}
