//
//  NewsCell.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var dateLable:UILabel!
    @IBOutlet weak var sourceLable: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var detailsLable: UILabel!
    @IBOutlet weak var newsImage:UIImageView!

    func congigure(with news: Article){
//        self.dateLable.text = String(news.publishedAt)
        self.sourceLable.text = news.content
        self.titleLable.text = news.content
        self.detailsLable.text = news.content
//            guard let imageData = news.urlToImage else { return }
//        userImage.image = UIImage(data: imageData)
        
    }
}


