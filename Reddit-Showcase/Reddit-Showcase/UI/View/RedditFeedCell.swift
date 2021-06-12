//
//  RedditFeedCell.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

class RedditFeedCell: UITableViewCell {
    @IBOutlet private(set) var tiltleLabel: UILabel!
    @IBOutlet private(set) var thumbnailImageView: UIImageView!
    @IBOutlet private(set) var commentLabel: UILabel!
    @IBOutlet private(set) var isReadedContainer: UIStackView!
    @IBOutlet private(set) var saveImage: UIStackView!
    @IBOutlet private(set) var authorAndTimeLabel: UILabel!
    
    var onImageTap: (() -> Void)?
    var onSaveTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        thumbnailImageView.addTapGesture(action: #selector(thumbnailImageViewTapped))
        saveImage.addTapGesture(action:  #selector(thumbnailImageViewTapped))
    }
    
    @objc private func saveImageViewTapped() {
        onSaveTap?()
    }
    
    @objc private func thumbnailImageViewTapped() {
        onImageTap?()
    }
}


extension UIView {
    func addTapGesture(action: Selector?) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        addGestureRecognizer(tapGesture)
    }
}
