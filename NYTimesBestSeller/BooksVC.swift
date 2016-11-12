//
//  BooksVC.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/9/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


class BooksVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // configuring alamofire request for cacheing
    var manager = Alamofire.SessionManager.default
    let configuration = URLSessionConfiguration.default
    

    
    @IBOutlet weak var bookTableView: UITableView!

    @IBOutlet weak var segmentForSorting: UISegmentedControl!
    
    var bookTypeFromMainScreen: ListClass!
    var urlString: String?
    
    @IBOutlet weak var bookTypeLabel: UILabel!
    
    var bookArray:[BookClass] = []
   
    var lastSort:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // no title for backbutton
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        lastSort = UserDefaults.standard.object(forKey: "lastSort") as? String
        
        if lastSort == "rank" {
            self.segmentForSorting.selectedSegmentIndex = 0

        } else if lastSort == "week" {
            self.segmentForSorting.selectedSegmentIndex = 1

        }  else {
            self.segmentForSorting.selectedSegmentIndex = UISegmentedControlNoSegment

        }
        
        // cache policy for alamofire
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        manager = Alamofire.SessionManager(configuration: configuration)
        
        // setting datasource and delegate for tableview
        self.bookTableView.dataSource = self
        self.bookTableView.delegate = self
        
        // set label text to list type
        self.bookTypeLabel.text = "\(bookTypeFromMainScreen._listDisplayName)"
        
        
        
        
        // Get Current Date
        let currentDate  = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-dd-MM"
        let convertedDate = dateFormatter.string(from: currentDate)

        // Format Book Type for URL
        let booktypeForRequest = bookTypeFromMainScreen._listName.replacingOccurrences(of: " ", with: "-")
       let bookTypeLowercasedForRequest = booktypeForRequest.lowercased()
       
        // Create URLString for Request to nytimesbook api
       // urlString = "\(Base_List_Url)/\(bookTypeLowercasedForRequest)\(JSON_Format)\(APIKEY)"
        urlString = "\(Base_List_Url)\(convertedDate)/\(bookTypeLowercasedForRequest)\(JSON_Format)\(APIKEY)"

        
        
        bookTableView.isHidden = true

        // Get books data
        self.downloadBookData {
            
            
            if self.bookArray.count < 1 {
                // no reults for Todays date so not useing date in request
                self.urlString = "\(Base_List_Url)/\(bookTypeLowercasedForRequest)\(JSON_Format)\(APIKEY)"
                self.downloadBookData {

                    
                    if self.bookArray.count < 1 {
                    
                    } else {
                       self.populateTableView()
                    }
                
                }
                
                
                
            } else {
                
               self.populateTableView()
            }
            
        }
        
    }
    func populateTableView() {
        self.setUpSort()
        self.bookTableView.isHidden = false
        self.bookTableView.reloadData()
   
    }
    func setUpSort() {
        if self.lastSort == "rank" {
            self.sortByRank()
        } else if self.lastSort == "week" {
            self.sortByWeek()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
              return bookArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = bookTableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell {
            
          // confgure cell
            
            configureCell(cell: cell, indexpath: indexPath as NSIndexPath)
            return cell
            
        } else {
            
            return BookTableViewCell()
            
        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.performSegue(withIdentifier: bookToDetailsSegue, sender: bookArray[indexPath.row])
        
    }
    

    
    func downloadBookData(completed: @escaping DownloadComplete) {

        print(urlString!)
        // start alamofire request
        manager.request(urlString!).responseJSON { response in
            let result = response.result
            
            // parse to get result then add to an array of [BookClass]
            if let dict = result.value as? Dictionary<String, AnyObject> {

                if let list = dict["results"] as? [Dictionary<String, AnyObject>] {
    
                    for item in list {
                        
                        let book = BookClass(bookDictionary: item)

                        self.bookArray.append(book)
                    }

                }
            }
            completed()
            // done with task

        }
    }
    
    func configureCell(cell:BookTableViewCell, indexpath: NSIndexPath) {
        
        // update cell
        cell.configureCell(bookClass: self.bookArray[indexpath.row])
        
    }
    func sortByRank(){
        // sort by bookRank
        self.bookArray = self.bookArray.sorted(by: {
            $0._bookRank! < $1._bookRank!
        })
        self.bookTableView.reloadData()

        UserDefaults.standard.set("rank", forKey: "lastSort")
        lastSort = "rank"
        if lastSort != "rank" {
            UserDefaults.standard.synchronize()
        }

    }
    func sortByWeek(){
        UserDefaults.standard.set("week", forKey: "lastSort")
        lastSort = "week"
        
        // sort by weeks on the besst seller list
        self.bookArray =  self.bookArray.sorted(by: {
            $0._bookWeeksOnList! < $1._bookWeeksOnList!
        })
        
        self.bookTableView.reloadData()
        if lastSort != "week" {
            UserDefaults.standard.synchronize()
        }
        

    }
    @IBAction func segmentChange(_ sender: AnyObject) {
        
        // sort array
        if self.segmentForSorting.selectedSegmentIndex == 0 {
            
           
            // sort by bookRank
                sortByRank()
         
        } else if self.segmentForSorting.selectedSegmentIndex == 1 {
           
           
            // sort by weeks on the besst seller list
                sortByWeek()
        }
    }


    
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            // get segue  equipped with Book Object
        if segue.identifier == bookToDetailsSegue {
            let booksViewController = segue.destination as? BookDetailsVC
            
            let bookTypeForSegue = sender as! BookClass
            booksViewController?.bookForDetails = bookTypeForSegue
            
        }
        
        
    }
}

