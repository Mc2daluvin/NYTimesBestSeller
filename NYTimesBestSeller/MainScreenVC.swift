//
//  MainScreenVC.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/9/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import UIKit
import Alamofire
import CoreData



class MainScreenVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    // configuring alamofire request for cacheing
    var manager = Alamofire.SessionManager.default
    let configuration = URLSessionConfiguration.default

    
    
    
    @IBOutlet weak var bookTypeTableView: UITableView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var noConnectionImageView: UIImageView!
    @IBOutlet weak var connectToInternetButton: UIButton!
    @IBOutlet weak var nyTimesLogoImageView: UIImageView!
    
    var bookTypes:[ListClass] = []
   
    override func viewDidAppear(_ animated: Bool) {
        // Get list data
        self.downloadBookTypes {
            // get booktypes count is greater than 1 show the tableView
            if self.bookTypes.count < 1 {

                self.noInternetOrBeforeLoading()

                
            } else {
                self.bookTypeTableView.isHidden = false
                self.bookTypeTableView.reloadData()

            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cache policy for alamofire
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        manager = Alamofire.SessionManager(configuration: configuration)

        // setting datasource and delegate for tableview
        self.bookTypeTableView.dataSource = self
        self.bookTypeTableView.delegate = self
        
        
        
        }
    
        


    func noInternetOrBeforeLoading() {
        bookTypeTableView.isHidden = true
        connectToInternetButton.isHidden = false
        noConnectionImageView.isHidden = false
        nyTimesLogoImageView.isHidden = false
        topLabel.text = "You Have 👌 Connection"
    }
    
    

    
    func downloadBookTypes(completed: @escaping DownloadComplete) {
        
        // create url for request
        let url = URL(string: "\(Base_List_Url)names\(JSON_Format)\(APIKEY)")
        // start alamofire request
        manager.request(url!).responseJSON { response in
   
            let result = response.result
            
            // parse to get result then add to an array of [ListClass]
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["results"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let type = ListClass(listTypeDict:obj)
                        
                        
                        self.bookTypes.append(type)
                    }
                    self.bookTypeTableView.reloadData()
                }
            }
            // done with task
            completed()
        }
    }
    func configureCell(cell:BookTypeTableViewCell, indexpath: NSIndexPath) {
        
        // configure cell with book at array indexPath
        cell.configureCell(listTypeClass:bookTypes[indexpath.row])
        

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return bookTypes.count

    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = bookTypeTableView.dequeueReusableCell(withIdentifier: "bookTypeCell", for: indexPath) as? BookTypeTableViewCell {
            
            // cell configure
                configureCell(cell: cell, indexpath: indexPath as NSIndexPath)
            
            return cell
            
        } else {
            
            return BookTypeTableViewCell()

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
            self.performSegue(withIdentifier: typeToBookSegue, sender: bookTypes[indexPath.row])
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // get segue  equipped with List Object
        if segue.identifier == typeToBookSegue {
            let booksViewController = segue.destination as? BooksVC

            let bookTypeForSegue = sender as! ListClass
            booksViewController?.bookTypeFromMainScreen = bookTypeForSegue
            
        }
        
        
    }
    

    
    
    @IBAction func tryAgainAction(_ sender: Any) {
        
        
        // if theres internet now do the request
        if Reachability.isConnectedToNetwork() == true
        {
            bookTypeTableView.isHidden = false
            noConnectionImageView.isHidden = true
            connectToInternetButton.isHidden = true
            nyTimesLogoImageView.isHidden = true
            
            topLabel.text = "Book Types"
            
            self.downloadBookTypes {
               self.bookTypeTableView.reloadData()
                
                    }

        }
        else
        {
            bookTypeTableView.isHidden = true
            
        }

        
    }
    

}
