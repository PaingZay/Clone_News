//
//  BreakingNewsManager.swift
//  BBCClone
//
//  Created by Paing Zay on 8/10/23.
//

import Foundation

protocol BreakingNewsDelegate {
    func didUpdateBreakingNews(_ breakingNewsManager: BreakingNewsManager, news:[NewsModel])
    func didFailedWithError(error:Error)
}

struct BreakingNewsManager {
     let baseUrl = "https://newsapi.org/v2/everything?q=Apple&sortBy=popularity&apiKey=4bcda235111d4b179b97b98d5bc6bfbb&from="
    
    var delegate: BreakingNewsDelegate?
    
    func fetchBreakingNews() {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let formattedDate = dateFormatter.string(from: currentDate)
        
        let urlTemplate = "\(baseUrl)&\(formattedDate)"
        
        performRequest(urlString: urlTemplate)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                if let safeData = data {
                    if let news = self.parseJSON(newsData: safeData) {
                        self.delegate?.didUpdateBreakingNews(self, news: news)
                    }
                }
            }
            
            task.resume()
        }
    }
    
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
