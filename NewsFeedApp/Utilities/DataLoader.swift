//
//  DataLoader.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 3.04.21.
//

import Foundation

enum NewsApiError: String {
    case invalidURL
    case noDataAvailable
    case parsingError
}

class DataLoader {
    func request(_ request: NewsRequest,
                 then completion: @escaping (Response?, NewsApiError?)->Void) {
        guard let url = request.requestURL else {
            completion(nil, .invalidURL)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil, .noDataAvailable)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
//                print(response)
                completion(response, nil)
            } catch {
                completion(nil, .parsingError)
            }
        }
        dataTask.resume()
    }
}
