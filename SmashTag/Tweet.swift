//
//  Tweet.swift
//  SmashTag
//
//  Created by Robert Dunbar on 18/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class Tweet: NSManagedObject {
    
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, searchTerm searchText: String, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as?
            Tweet {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.tweeter = TwitterUser.tweetUserTwitterInfo(twitterInfo.user, inManagedObjectContext: context)
            tweet.search = SearchTerm.searchWithSearchInfo(searchText, inManagedObjectContext: context)
            for hashInfo in twitterInfo.hashtags {
                _ = Mention.mentionWithTwitterInfo(hashInfo, searchTerm: searchText, inManagedObjectContext: context)
            }
            for userInfo in twitterInfo.userMentions {
                _ = Mention.mentionWithTwitterInfo(userInfo, searchTerm: searchText, inManagedObjectContext: context)
            }
            return tweet
        }
        return nil
    }
    
}

