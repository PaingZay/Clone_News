//
//  CategorizedNewsController.swift
//  BBCClone
//
//  Created by Paing Zay on 21/9/23.
//

import UIKit

class CategorizedNewsController: UIViewController {
    
    var news: [NewsModel]?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var publishedAt: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var headerLabelHeight: NSLayoutConstraint!
    let minimumHeight: CGFloat = 50.0
    @IBOutlet weak var authorLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentNews = 0
    
    var imageManager = ImageManager()
    
    var loadedImage: UIImage?
    
    var newsManager = NewsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
                let nib = UINib(nibName: Constants.newsCellNibName, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: Constants.newsCellIdentifier)
        
        authorLabel.text = news?[currentNews].author
        headerLabel.text = news?[currentNews].title
        contentLabel.text = news?[currentNews].content
        publishedAt.text = news?[currentNews].publishedAt
        
        imageManager.delegate = self
        imageManager.getImage(imageUrl: news?[0].urlToImage ?? "https://gg.com")
        
        resizeElementHeight(targetElement: headerLabel, layoutConstraint: headerLabelHeight)
        resizeElementWidth(targetElement: authorLabel, layoutConstraint: authorLabelWidth)
    }
}

extension CategorizedNewsController {
    func resizeElementHeight(targetElement: UIView, layoutConstraint: NSLayoutConstraint) {
        let labelSize = targetElement.sizeThatFits(CGSize(width: targetElement.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        let requiredHeight = labelSize.height * 1.5
        layoutConstraint.constant = max(requiredHeight, minimumHeight)
        
        // Apply the constraint change.
        view.layoutIfNeeded()
    }
    
    func resizeElementWidth(targetElement: UIView, layoutConstraint: NSLayoutConstraint) {
        
        let labelSize = targetElement.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: targetElement.frame.size.height))
        
        let requiredWidth = labelSize.width
        layoutConstraint.constant = requiredWidth
        
        view.layoutIfNeeded()
    }
}

let path = 0

extension CategorizedNewsController: ImageManagerDelegate {
    func didRelatedNewsImageLoaded(_ imageManager: ImageManager, urlImage: UIImage) {
        self.loadedImage = urlImage
    }
    
    func didImageLoaded(_ imageManager: ImageManager, urlImage: UIImage) {
        //HAVE TO CHECK
            DispatchQueue.main.async {
                self.newsImage.image = urlImage
            }
        }
    func didFailedWithError(error: Error) {
        print("Image Loading Failed \(error)")
    }
}


extension CategorizedNewsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let news = news {
//            return news.count
//        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newsCellIdentifier, for: indexPath) as! RelatedNewsCell
        if let news = news {
            
            cell.header.text = news[indexPath.row].title
            cell.content.text = news[indexPath.row].content
            
            imageManager.getRelatedNewsImage(imageUrl: news[indexPath.row].urlToImage ?? "https://example.com") {
                image in
                    if let image = image {
                        DispatchQueue.main.async {
                            cell.newsImage.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.newsImage.image = UIImage(named: "No_image_available")
                        }
                    }
            }
        }
        return cell
        
    }
    
    
}

extension CategorizedNewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentNews = indexPath.row
        headerLabel.text = news?[currentNews].title
//        updateView()
    }
}




//extension CategorizedNewsController {
//    func updateView() {
//        loadView()
//    }
//}
