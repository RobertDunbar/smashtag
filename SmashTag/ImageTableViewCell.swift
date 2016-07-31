//
//  ImageTableViewCell.swift
//  SmashTag
//
//  Created by Robert Dunbar on 11/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailedImage: UIImageView!
    
    var thisImage: MediaItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        detailedImage?.image = nil
        
        if let tweetImageURL = thisImage?.url {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)) {
                if let imageData = NSData(contentsOfURL: tweetImageURL) { // blocks main thread!
                    dispatch_async(dispatch_get_main_queue()) {
                        self.detailedImage?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
    }

}
