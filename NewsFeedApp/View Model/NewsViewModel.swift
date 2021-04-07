//
//  NewsViewNodel.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import Foundation

class NewsViewModel: Codable {
    let title: String
    var date: String?
    let imageURL: String
    let sourceName: String
    let articleURL: String
    let description: String
    
    init(model: Article) {
        title = model.title ?? ""
        if let date = model.publishedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.apiDateFormat
            self.date = dateFormatter.date(from: date)?.toString(dateFormat: Constants.displayDateFormat)
        }
        imageURL = model.urlToImage ?? ""
        sourceName = model.source?.name ?? ""
        articleURL = model.url ?? ""
        description = model.description ?? ""
    }
}
