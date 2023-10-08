//
//  NewsManager.swift
//  BBCClone
//
//  Created by Paing Zay on 20/9/23.
//

import Foundation

protocol NewsManagerDelegate {
    func didUpdateNews(_ newsManager: NewsManager, news:[NewsModel])
    func didFailedWithError(error:Error)
}

struct NewsManager {
    let newsUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=4bcda235111d4b179b97b98d5bc6bfbb"
    
    var delegate: NewsManagerDelegate?
    
    func fetchNews(category: String){
        let urlString = "\(newsUrl)&category=\(category)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                
                if let safeData = data {
                    //Parse data into a String
                    /*let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)*/
                    
                    if let news = self.parseJSON(newsData: safeData) {
                        self.delegate?.didUpdateNews(self, news: news)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    //Wanna return nil so the return type must be Optional
    func parseJSON(newsData: Data) -> [NewsModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self,from:newsData)
            
            var articles: [NewsModel] = []
            
            for article in decodedData.articles {
                
                let source = article.source.name
                let author = article.author
                let title = article.title
                let description = article.description
                let url = article.url
                let urlToImage = article.urlToImage
                let publishedAt = article.publishedAt
                let content = article.content
                
                let news = NewsModel(source: source, author: author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
                
                articles.append(news)
            }
            
//            return news
            return articles
            
        } catch {
            print(error)
            return nil
        }
    }
}
