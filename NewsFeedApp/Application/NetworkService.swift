//
//  NetworkService.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private let coursesURL = "https://api.github.com/users?per_page=10&since=0"
    
    func fetchData(urll: String,completion: @escaping (_ courses: [Article])->()) {
        
        guard let url = URL(string: urll) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Article].self, from: data)
                completion(courses)
            } catch let error {
                print("Error serialization json", error)
            }
            
        }.resume()
    }
}
