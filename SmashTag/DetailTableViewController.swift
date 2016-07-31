//
//  DetailTableViewController.swift
//  SmashTag
//
//  Created by Robert Dunbar on 11/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import UIKit
import Twitter

class DetailTableViewController: UITableViewController {
    
    private struct StoryBoard {
        static let ImageCellIdentifier = "Show Image"
        static let DetailCellIdentifier = "Show Detail"
        static let SearchDetailSegue = "Search Detail"
        static let ScrollImageSegue = "Scroll Image"
    }
    
    // MODEL
    
    private var brokenTweet = [Array<TweetContents>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var detailTweet: Twitter.Tweet? {
        didSet {
            brokenTweet.append(pullSectionData(detailTweet!, type: "Image"))
            brokenTweet.append(pullSectionData(detailTweet!, type: "Hashtags"))
            brokenTweet.append(pullSectionData(detailTweet!, type: "Users"))
            brokenTweet.append(pullSectionData(detailTweet!, type: "Urls"))
        }
    }
    
    private func pullSectionData(tweet: Twitter.Tweet, type: String) -> [TweetContents] {
        var tempSection = Array<TweetContents>()
        switch type {
        case "Image":
            for data in detailTweet!.media {
                tempSection.append(TweetContents.Image(data))
            }
        case "Hashtags":
            for data in detailTweet!.hashtags {
                tempSection.append(TweetContents.Hashtags(data))
            }
        case "Users":
            for data in detailTweet!.userMentions {
                tempSection.append(TweetContents.Users(data))
            }
        case "Urls":
            for data in detailTweet!.urls {
                tempSection.append(TweetContents.Urls(data))
            }
        default:
            break
        }
        return tempSection
    }
    


    private enum TweetContents {
        case Image (MediaItem)
        case Hashtags (Twitter.Mention)
        case Users (Twitter.Mention)
        case Urls (Twitter.Mention)
    }
    
    private var sectionHeaders: Dictionary<Int,String> = [
        0 : "Image",
        1 : "Hashtags",
        2 : "User Mentions",
        3 : "Urls"
    ]
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let detail = brokenTweet[indexPath.section][indexPath.row]
        switch detail {
        case .Image(let thisImage):
            return tableView.bounds.width / CGFloat(thisImage.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return !brokenTweet[section].isEmpty ? sectionHeaders[section] : ""
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return brokenTweet.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return brokenTweet[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let detail = brokenTweet[indexPath.section][indexPath.row]
        let defaultCell = UITableViewCell()
        
        switch detail {
        case .Image(let thisImage):
            let imageCell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.ImageCellIdentifier, forIndexPath: indexPath)
            if let whatIsCell = imageCell as? ImageTableViewCell {
                whatIsCell.thisImage = thisImage
                return imageCell
            }
        case .Hashtags(let thisDetail):
            let detailCell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.DetailCellIdentifier, forIndexPath: indexPath)
            if let whatIsCell = detailCell as? DetailTableViewCell {
                whatIsCell.thisDetail = thisDetail
                return detailCell
            }
        case .Urls(let thisDetail):
            let detailCell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.DetailCellIdentifier, forIndexPath: indexPath)
            if let whatIsCell = detailCell as? DetailTableViewCell {
                whatIsCell.thisDetail = thisDetail
                return detailCell
            }
        case .Users(let thisDetail):
            let detailCell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.DetailCellIdentifier, forIndexPath: indexPath)
            if let whatIsCell = detailCell as? DetailTableViewCell {
                whatIsCell.thisDetail = thisDetail
                return detailCell
            }
        }
        return defaultCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let segueData = brokenTweet[indexPath.section][indexPath.row]
        switch segueData {
        case .Hashtags(let detailData):
            performSegueWithIdentifier(StoryBoard.SearchDetailSegue, sender: detailData.keyword)
        case .Users(let detailData):
            performSegueWithIdentifier(StoryBoard.SearchDetailSegue, sender: detailData.keyword)
        case .Urls(let detailData):
            UIApplication.sharedApplication().openURL(NSURL(string: detailData.keyword)!)
        case .Image(let detailData):
            performSegueWithIdentifier(StoryBoard.ScrollImageSegue, sender:  detailData.url)
        }
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.SearchDetailSegue {
            let detailSegueMVC = segue.destinationViewController as? TweetTableViewController
            detailSegueMVC!.searchText = String(sender!)
        } else if segue.identifier == StoryBoard.ScrollImageSegue {
            let detailSegueMVC = segue.destinationViewController as? ImageViewController
            detailSegueMVC!.imageURL = sender as? NSURL
        }
    }
    
}
