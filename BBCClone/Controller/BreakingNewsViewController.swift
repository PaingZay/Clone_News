//
//  BreakingNewsViewController.swift
//  BBCClone
//
//  Created by Paing Zay on 5/10/23.
//

import UIKit
import Kingfisher

class BreakingNewsViewController: UIViewController {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newsContent: UITextView!
    @IBOutlet weak var newsContentHeight: NSLayoutConstraint!
    
    
    var news: [NewsModel]?
    
    var newsManager = NewsManager()
    var currentNewsIndex = 0
    
    var breakingNewsManager = BreakingNewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTitle.numberOfLines = 0
        newsTitle.lineBreakMode = .byWordWrapping
        
        breakingNewsManager.delegate = self
        breakingNewsManager.fetchBreakingNews()
        
        let nib = UINib(nibName: Constants.newsCellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.newsCellIdentifier)
        
        tableView.dataSource = self
    }
}

extension BreakingNewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = news {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellIdentifier, for: indexPath) as! RelatedNewsCell

        if let news = self.news {
            cell.header.lineBreakMode = .byWordWrapping
            cell.content.lineBreakMode = .byWordWrapping
            cell.header.text = news[indexPath.row].title
            cell.content.text = news[indexPath.row].content
            
            let newsImageUrl = news[indexPath.row].urlToImage
            
            if let newsImageUrl = newsImageUrl {
                let resource = KF.ImageResource(downloadURL: URL(string: newsImageUrl)!, cacheKey: newsImageUrl)
                
                cell.newsImage.kf.setImage(with: resource)
            }
        }
        
        return cell
    }
}

extension BreakingNewsViewController: BreakingNewsDelegate {
    func didUpdateBreakingNews(_ breakingNewsManager: BreakingNewsManager, news: [NewsModel]) {
        
        self.news = news
        
        if let currentNews = news.first, let imageUrlString = currentNews.urlToImage {
            
            let resource = KF.ImageResource(downloadURL: URL(string: imageUrlString)!, cacheKey: imageUrlString)
            
            DispatchQueue.main.async {
                
                self.newsTitle.text = currentNews.title
                self.imageView.kf.setImage(with: resource)
                
                self.resizeElementHeight(targetElement: self.newsContent, layoutConstraint: self.newsContentHeight)
                
                self.newsContent.text = currentNews.content
                
                self.tableView.reloadData()
            }
        }
    }

    func didFailedWithError(error: Error) {
        print("There is no data returned from the model")
    }
    
    func resizeElementHeight(targetElement: UIView, layoutConstraint: NSLayoutConstraint) {
        
        let minimumHeight: CGFloat = 50.0
        
        let labelSize = targetElement.sizeThatFits(CGSize(width: targetElement.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        let requiredHeight = labelSize.height * 3
        layoutConstraint.constant = max(requiredHeight, minimumHeight)
        
        // Apply the constraint change.
        view.layoutIfNeeded()
    }
}


