//
//  Date=String.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import Foundation

extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
