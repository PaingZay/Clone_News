//
//  NewsData.swift
//  BBCClone
//
//  Created by Paing Zay on 21/9/23.
//

import Foundation

struct NewsData: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String
}
