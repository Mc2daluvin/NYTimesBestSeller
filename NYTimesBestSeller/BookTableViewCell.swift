//
//  BookTableViewCell.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/10/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookTitleLabel: UILabel!
    

    // configure cell for book title
    
    func configureCell(bookClass: BookClass) {
        
        bookTitleLabel.text = bookClass._bookTitle
        
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
