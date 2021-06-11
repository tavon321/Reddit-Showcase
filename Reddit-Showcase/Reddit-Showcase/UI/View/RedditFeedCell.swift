//
//  RedditFeedCell.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import UIKit

class RedditFeedCell: UITableViewCell {
    @IBOutlet private(set) var tiltleLabel: UILabel!
    @IBOutlet private(set) var authorLabel: UILabel!
    @IBOutlet private(set) var thumbnailImageView: UIImageView!
    @IBOutlet private(set) var commentLabel: UILabel!
    @IBOutlet private(set) var isReadedContainer: UIStackView!
    @IBOutlet private(set) var timeAgoLabel: UILabel!
    
    var onTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailImageViewTapped))
        thumbnailImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func thumbnailImageViewTapped() {
        onTap?()
    }
}
