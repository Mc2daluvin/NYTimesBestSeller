//
//  Constants.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/9/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import Foundation






let Base_List_Url = "http://api.nytimes.com/svc/books/v2/lists/"
let APIKEY = "&api-key=b8df819932174af8b009f9eb61953c1a"
let JSON_Format = ".json"

let typeToBookSegue = "booksForCatagorieSegue"
let bookToDetailsSegue = "bookDetailsSegue"

typealias DownloadComplete = () -> ()
