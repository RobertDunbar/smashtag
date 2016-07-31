//
//  searchStore.swift
//  SmashTag
//
//  Created by Robert Dunbar on 14/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import Foundation

class SearchStore {
    
    private struct Constants {
        static let storageKey = "TwitterSearches"
        static let maxSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var storage: [AnyObject] {
        get {
            return defaults.objectForKey(Constants.storageKey) as? [AnyObject] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: Constants.storageKey)
        }
    }
    
    func addItem(item: String) {
        var currentSearches = storage
        
        if let index = (currentSearches as? [String])?.indexOf(item) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(item, atIndex: 0)
        if storage.count > Constants.maxSearches {
            storage.removeLast()
        }
        storage = currentSearches
    }
    
    
}