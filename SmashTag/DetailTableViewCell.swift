//
//  DetailTableViewCell.swift
//  SmashTag
//
//  Created by Robert Dunbar on 11/07/2016.
//  Copyright © 2016 Robert Dunbar. All rights reserved.
//

import UIKit
import Twitter

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var detailedLabel: UILabel!
    
    var thisDetail: Twitter.Mention? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        detailedLabel?.text = nil
        
        if let mentionData = thisDetail?.keyword {
            detailedLabel.text = mentionData
        }
        
    }

}
