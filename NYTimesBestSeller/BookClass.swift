//
//  BookClass.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/9/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import Foundation

// Class for Parsing Json of each Book

class BookClass {
    
    
    fileprivate var bookTitle:String?
    fileprivate var bookAuthor:String?
    fileprivate var bookDescription:String?
    fileprivate var bookReviewLinkNYTimes:String?
    fileprivate var bookLinkAmazon:String?
    fileprivate var bookRank:Int?
    fileprivate var bookWeeksOnList:Int?
    fileprivate var bookImageURL:String?
    
    
    // get private values of variebles
    // variebles could only be set in initializer
    // also if a variable hasnt been set yet give it a default value
    
    
    var _bookTitle:String {
        if bookTitle == nil {
            bookTitle = "N/A"
        }
        return bookTitle!
    }
    
    var _bookAuthor:String{
        if bookAuthor == nil {
            bookAuthor = "N/A"
        }
        return bookAuthor!

    }
    var _bookDescription:String{
        if bookDescription == nil {
             bookDescription = "N/A"
        }
        return bookDescription!

    }
    var _bookReviewLinkNYTimes:String{
        if bookReviewLinkNYTimes == nil {
            bookReviewLinkNYTimes = ""
        }
        return bookReviewLinkNYTimes!

    }
    var _bookLinkAmazon:String{
        if bookLinkAmazon == nil {
            bookLinkAmazon = ""
        }
        return bookLinkAmazon!

    }
    
    var _bookRank:Int?{
        if bookRank == nil {
            bookRank = 0
        }
        return bookRank
    }
    var _bookWeeksOnList:Int?{
        if bookWeeksOnList == nil {
            bookWeeksOnList = 0
        }
        return bookWeeksOnList
    }
    var _bookImageURL:String {
        if bookImageURL == nil {
            bookImageURL = ""
        }
        return bookImageURL!
    }

    
    init(bookDictionary: Dictionary<String,AnyObject>) {
        
        // parsing Book Item
        
        if let detailsForBook = bookDictionary["book_details"] as? [Dictionary<String,AnyObject>] {
            
            if let titleForBook = detailsForBook[0]["title"] as? String {
                self.bookTitle = titleForBook
            }
            if let authorForBook = detailsForBook[0]["author"] as? String {
                self.bookAuthor = authorForBook
            }
            if let descriptionForBook = detailsForBook[0]["description"] as? String {
                self.bookDescription = descriptionForBook
            }
            if let amazonProductUrl = detailsForBook[0]["amazon_product_url"] as? String {
                self.bookLinkAmazon = amazonProductUrl
            }
            if let bookImageUrlForBook = detailsForBook[0]["book_image"] as? String {
                self.bookImageURL = bookImageUrlForBook
            }


            
            
        } // end of bookDetails
        
        if let rankForBook = bookDictionary["rank"] as? Int {
            self.bookRank = rankForBook
        }
        if let weeksOnListForBook = bookDictionary["weeks_on_list"] as? Int {
            self.bookWeeksOnList = weeksOnListForBook
        }
        
        if let reviewForBook = bookDictionary["reviews"] as? [Dictionary<String,AnyObject>] {
            
            if let nytimesReviewForBook = reviewForBook[0]["book_review_link"] as? String {
                
                self.bookReviewLinkNYTimes = nytimesReviewForBook
                
            }
            
        }// end of reviewForBook
        
    }
    
}









