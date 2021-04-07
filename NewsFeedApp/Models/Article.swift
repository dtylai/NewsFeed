//
//  Article.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import Foundation

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
