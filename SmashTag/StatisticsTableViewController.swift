//
//  StatisticsTableViewController.swift
//  SmashTag
//
//  Created by Robert Dunbar on 19/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import UIKit
import CoreData

class StatisticsTableViewController: CoreDataTableViewController {
    
    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func updateUI() {
        if let context = managedObjectContext where mention?.characters.count > 0 {
            let request = NSFetchRequest(entityName: "Mention")
            request.predicate = NSPredicate(format: "any search.text == %@ and count > 1", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key: "count",
                ascending: false),
                NSSortDescriptor(
                    key: "label",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }

     // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StaticticsCell", forIndexPath: indexPath) as! StatisticsTableViewCell
        
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention {
            var screenName: String?
            mention.managedObjectContext?.performBlockAndWait {
                screenName = mention.label
            }
            cell.MentionLabel?.text = screenName
            cell.CountLabel?.text = String(mention.count!)
        }
        return cell
    }
    

 
}
