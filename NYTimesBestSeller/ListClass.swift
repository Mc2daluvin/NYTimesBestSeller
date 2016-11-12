//
//  ListClass.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/10/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import Foundation

// Class for Parsing List Item of each List


class ListClass: NSCoding {
    
    private var listName: String!
    private var listDisplayName: String!

    
    
    var _listName: String {
        if listName == nil {
            self.listName = ""
        }
        return listName
        
    }
    
    var _listDisplayName: String {
        if listDisplayName == nil {
            self.listDisplayName = ""
        }
        return listDisplayName
        
    }

    func encode(with aCoder: NSCoder) {
        
    }
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    init(listTypeDict: Dictionary<String, AnyObject>) {
        
        // get encoded list name of url
        if let bookTypeListName = listTypeDict["list_name_encoded"] as? String {
            
            self.listName = bookTypeListName
        }
        // get list name for displaying purposes
        if let bookTypeDisplayListName = listTypeDict["display_name"] as? String {
            
            self.listDisplayName = bookTypeDisplayListName
        }
  
        
    }
    
}
