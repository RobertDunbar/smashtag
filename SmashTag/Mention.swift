//
//  Mention.swift
//  SmashTag
//
//  Created by Robert Dunbar on 22/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class Mention: NSManagedObject {

    class func mentionWithTwitterInfo(mentionInfo: Twitter.Mention, searchTerm searchText: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "label = %@", mentionInfo.keyword)
        
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention {
            var counter = Int(mention.count!)
            counter += 1
            mention.count = counter
            return mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as?
            Mention {
            mention.label = mentionInfo.keyword
            mention.count = 1
            mention.search = SearchTerm.searchWithSearchInfo(searchText, inManagedObjectContext: context)
            return mention
        }
        return nil
    }

}
