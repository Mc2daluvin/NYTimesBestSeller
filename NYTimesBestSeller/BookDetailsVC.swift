//
//  BookDetailsVC.swift
//  NYTimesBestSeller
//
//  Created by McGerald Lezeau on 11/9/16.
//  Copyright © 2016 McGerald Lezeau. All rights reserved.
//

import UIKit
import SafariServices

class BookDetailsVC: UIViewController, SFSafariViewControllerDelegate {

    
    var bookForDetails: BookClass!
    
    var webSafari :SFSafariViewController!
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var amazonLinkButton: UIButton!
    @IBOutlet weak var nytimesReviewLinkButton: UIButton!

    var amazonLink:String!
    var reviewLink:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // no title for backbutton
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }

        
        // set values to labels
        self.bookTitleLabel.text = bookForDetails._bookTitle
        self.bookAuthorLabel.text = bookForDetails._bookAuthor
        self.bookDescriptionLabel.text = bookForDetails._bookDescription

        
        // if links are empty disable the button and change the button title
        if bookForDetails._bookLinkAmazon == "" {
            amazonLinkButton.setTitle("Amazon Link N/A", for: .normal)
            amazonLinkButton.isEnabled = false

        } else {
           amazonLink = bookForDetails._bookLinkAmazon
        }
        if bookForDetails._bookReviewLinkNYTimes == "" {
            nytimesReviewLinkButton.setTitle("NYTimes Review N/A", for: .normal)
            nytimesReviewLinkButton.isEnabled = false
        } else {
            reviewLink = bookForDetails._bookReviewLinkNYTimes
        }
        
        
        // download image to the image view using extention for async download
        if bookForDetails._bookImageURL != "" {
            bookImageView.downloadedFrom(link: bookForDetails._bookImageURL, contentMode: .scaleAspectFit)
        }
        
    }

   
    
    
    @IBAction func goToReviewLink(_ sender: Any) {
        // go to NYtimes review link using SFSafariViewController
        webSafari = SFSafariViewController(url:URL(string: self.reviewLink!)!)
        webSafari.view.tintColor = UIColor.red
        webSafari.delegate = self
        
        self.present(webSafari, animated: true, completion:nil)

    }

    @IBAction func goToAmazonLink(_ sender: Any) {
        // go to Amazon Product URL using SFSafariViewController
        webSafari = SFSafariViewController(url:URL(string: self.amazonLink!)!)
        webSafari.view.tintColor = UIColor.red
        webSafari.delegate = self
        
        self.present(webSafari, animated: true, completion:nil)
        

    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}

extension UIImageView {
    
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 7.0
        //        self.image = nil
        guard
            let url = URL(string: link)
            else {return}
    
            contentMode = mode
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                guard
                    let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                    let data = data , error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async { () -> Void in             
                  self.image = image
                }
            }).resume()
        }
    
    
}

