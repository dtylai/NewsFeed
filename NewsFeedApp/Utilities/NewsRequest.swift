//
//  NewsRequest.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import Foundation

enum Endpoint: String {
    case everything = "everything"
}

enum RequestParameter: String {
    case query = "q"
    case pageSize
    case pageNumber
    case page
    case apiKey
    case sortBy
    case domains
    case from
    case to
}

struct NewsRequest {
    
    let scheme = "http"
    let host = "newsapi.org"
    var endpoint: Endpoint
    var params: [RequestParameter: String]
    
    
    var requestURL: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/v2/\(endpoint.rawValue)"
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: RequestParameter.apiKey.rawValue, value: Constants.apiKey))
        for param in params {
            let queryItem = URLQueryItem(name: param.key.rawValue, value: param.value)
            queryItems.append(queryItem)
        }
        components.queryItems = queryItems
        return components.url
    }
    
    init(endpoint: Endpoint, params: [RequestParameter: String]) {
        self.endpoint = endpoint
        self.params = params
    }
    
    
    static func everything( pageSize: Int, timeFrom: Date, timeTo:Date) -> NewsRequest {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.requestDateFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)! as TimeZone
        var params = [RequestParameter: String]()
        params[.domains]="lenta.ru"
        params[.pageSize] = "\(pageSize)"
//        params[.page] = "\(pageNumber)"
        params[.from] = formatter.string(from: timeFrom  as Date)
        params[.to] = formatter.string(from: timeTo  as Date)
        return NewsRequest(endpoint: .everything, params: params)
    }

}
