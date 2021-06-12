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
    @IBOutlet private(set) var saveImage: SaveImageView!
    @IBOutlet private(set) var authorAndTimeLabel: UILabel!
    
    var onImageTap: (() -> Void)?
    var onSaveTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        thumbnailImageView.addTapGesture(action: #selector(thumbnailImageViewTapped), target: self)
        saveImage.addTapGesture(action:  #selector(saveImageViewTapped), target: self)
    }
    
    @objc private func saveImageViewTapped() {
        saveImage.showAnimation { [weak self] in
            self?.onSaveTap?()
        }
    }
    
    @objc private func thumbnailImageViewTapped() {
        onImageTap?()
    }
}
