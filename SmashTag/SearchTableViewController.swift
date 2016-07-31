//
//  SearchTableViewController.swift
//  SmashTag
//
//  Created by Robert Dunbar on 14/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController {
    
    private struct StoryBoard {
        static let SearchCellIdentifier = "Search Cell"
        static let SearchDetailSegue = "Search Detail"
        static let SearchStatisticsSegue = "TweetStatisticsSegue"


    }

    private var searchStore = SearchStore()
    
    private var searchTerms = [String]()
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search History"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchTerms = searchStore.storage as? [String] ?? []
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStore.storage.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.SearchCellIdentifier, forIndexPath: indexPath)
        let searchItem = searchTerms[indexPath.row]
        if let searchItemCell = cell as? SearchTableViewCell {
            searchItemCell.searchLabel.text = searchItem
        }
        return cell
    }
    

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.SearchDetailSegue {
            if let cell = sender as? SearchTableViewCell,
                let indexPath = tableView.indexPathForCell(cell) {
                let detailSegueMVC = segue.destinationViewController as? TweetTableViewController
                detailSegueMVC!.searchText = searchTerms[indexPath.row]
            }
        } else if segue.identifier == StoryBoard.SearchStatisticsSegue {
            if let cell = sender as? SearchTableViewCell,
                let indexPath = tableView.indexPathForCell(cell) {
                let statisticsSegueMVC = segue.destinationViewController as? StatisticsTableViewController
                statisticsSegueMVC!.mention = searchTerms[indexPath.row]
                statisticsSegueMVC!.managedObjectContext = managedObjectContext
                print("nffgeror")
            }
        }
    }
    

}
