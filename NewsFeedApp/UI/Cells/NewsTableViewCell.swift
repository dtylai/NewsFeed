//
//  NewsTableViewCell.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import UIKit
import SDWebImage


class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var NewsDescription: UILabel!
    @IBOutlet weak var datePublished: UILabel!

    var viewModel: NewsViewModel?
    var NewsURL: String?
    
    let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 14.0)
    let readmoreFontColor = UIColor.blue
    
    func setup(with news: NewsViewModel) {
//        NewsDescription.numberOfLines = 3
        title.text = news.title
        source.text = news.sourceName
        NewsDescription.text = news.description
        
//        if news.description.count > 120 {
        NewsDescription.addTrailing(with: "... ", moreText: "Show more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
//        }
        datePublished.text = news.date
        newsImageView.sd_setImage(with: URL(string: news.imageURL), placeholderImage: UIImage(named: "placeholder.png"))
        NewsURL = news.articleURL
        viewModel = news
    }

    
    
    func cellSelected() {
        guard let url = URL(string: NewsURL ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
}

extension UILabel {

        func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
            let readMoreText: String = trailingText + moreText

            let lengthForVisibleString: Int = self.vissibleTextLength
            let mutableString: String = self.text!
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
            let readMoreLength: Int = (readMoreText.count)
            let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }

        var vissibleTextLength: Int {
            let font: UIFont = self.font
            let mode: NSLineBreakMode = self.lineBreakMode
            let labelWidth: CGFloat = self.frame.size.width
            let labelHeight: CGFloat = self.frame.size.height
            let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                    }
                } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
            return self.text!.count
        }
    }
