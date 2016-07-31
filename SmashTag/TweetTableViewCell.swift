//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Robert Dunbar on 08/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

 
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        var tweetMustableString = NSMutableAttributedString()
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetMustableString = NSMutableAttributedString(string: tweet.text as String)
            for hashtagLoop in tweet.hashtags {
                tweetMustableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: (hashtagLoop).nsrange)
            }
            for urlLoop in tweet.urls {
                tweetMustableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: (urlLoop).nsrange)
            }
            for userMentionLoop in tweet.userMentions {
                tweetMustableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: (userMentionLoop).nsrange)
            }
            
            tweetTextLabel?.attributedText = tweetMustableString
            if tweetTextLabel?.attributedText != nil  {
                for _ in tweet.media {
                    tweetMustableString.appendAttributedString(NSAttributedString(string: " 📷"))
                    tweetTextLabel.attributedText! = tweetMustableString
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
}
