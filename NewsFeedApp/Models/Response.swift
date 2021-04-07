//
//  News.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import Foundation

struct Response: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
    let sources: [Source]?
}
