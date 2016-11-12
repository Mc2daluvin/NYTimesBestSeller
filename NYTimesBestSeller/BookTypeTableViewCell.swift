//
//  BookTypeTableViewCell.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/10/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import UIKit

class BookTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var bookTypeLabel: UILabel!
    
    
    // configure cell for list type
    
      func configureCell(listTypeClass: ListClass) {
        
        bookTypeLabel.text = listTypeClass._listDisplayName
        
                
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
