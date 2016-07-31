//
//  SearchTerm.swift
//  SmashTag
//
//  Created by Robert Dunbar on 22/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import Foundation
import CoreData


class SearchTerm: NSManagedObject {
    
    class func searchWithSearchInfo(searchInfo: String, inManagedObjectContext context: NSManagedObjectContext) -> SearchTerm? {
        let request = NSFetchRequest(entityName: "SearchTerm")
        request.predicate = NSPredicate(format: "text = %@", searchInfo)
        
        if let searchTerm = (try? context.executeFetchRequest(request))?.first as? SearchTerm {
            return searchTerm
        } else if let searchTerm = NSEntityDescription.insertNewObjectForEntityForName("SearchTerm", inManagedObjectContext: context) as?
            SearchTerm {
            searchTerm.text = searchInfo
            return searchTerm
        }
        return nil
    }

    
}
