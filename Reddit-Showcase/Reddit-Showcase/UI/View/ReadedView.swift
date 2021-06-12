//
//  ReadedView.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

final class ReadedView: UIStackView {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    public var isReaded: Bool = false {
        didSet {
            if isReaded {
                label.text = "Read"
                label.textColor = .green
                imageView.image = UIImage(systemName: "eye.fill")
                imageView.tintColor = .green
            } else {
                label.text = "Unread"
                label.textColor = .lightGray
                imageView.image = UIImage(systemName: "eye.slash.fill")
                imageView.tintColor = .lightGray
            }
        }
    }
}
