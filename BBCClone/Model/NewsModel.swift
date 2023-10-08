//
//  NewsModel.swift
//  BBCClone
//
//  Created by Paing Zay on 21/9/23.
//

import Foundation

struct NewsModel: Codable {
    let source: String //Should be array Since there might be multiple sources
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
