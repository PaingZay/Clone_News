//
//  ViewController.swift
//  BBCClone
//
//  Created by Paing Zay on 20/9/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var newsManager = NewsManager()
    
    var news: [NewsModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        newsManager.delegate = self
        
        //Register Xib with the Table View
        tableView.register(UINib(nibName: Constants.categoryCellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

//UITable ViewDataSource means When tableView loads up it's going to make a request for data
extension ViewController: UITableViewDataSource {
    //NumberOfRowsInSection means how many rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! CategoryCell //Required downcat
        //cell.label is the IBOutlet within CategoryCell class
        cell.label.text = Constants.categories[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Fetch Categorized News Callback
        newsManager.fetchNews(category: Constants.categories[indexPath.row])
        
        //CLICK TABLE VIEW CELL
        //THEN Fetch Not Go To Next Page Immediately
    }
}

extension ViewController: NewsManagerDelegate {
    func didUpdateNews(_ newsManager: NewsManager, news:[NewsModel]) {
          
        //I am gonna declare a global variable in order to send to next page

        self.news = news
        goToNextPage()
    }
    
    func didFailedWithError(error:Error) {
        print("Fetch Failed \(error)")
    }
}

extension ViewController {
    //Goto next page
    func goToNextPage() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "gotoCategorizedNews", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "gotoCategorizedNews" {
            let destinationVC = segue.destination as! CategorizedNewsController
            destinationVC.news = news
        }
    }
}
