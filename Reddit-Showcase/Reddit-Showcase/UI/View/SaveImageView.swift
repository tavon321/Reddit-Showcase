//
//  SaveImageView.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

public final class SaveImageView: UIStackView {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                label.text = "Loading.."
                label.textColor = .lightGray
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                imageView.isHidden = true
            } else {
                activityIndicator.isHidden = true
                label.text = "Saved"
                label.textColor = .green
                isUserInteractionEnabled = false
                imageView.isHidden = false
                imageView.image = UIImage(systemName: "checkmark.circle")?
                    .withRenderingMode(.alwaysTemplate)
                imageView.tintColor = .green
            }
        }
    }
    
    public func finish(error: Bool) {
        if error {
            label.text = "Failed"
            label.textColor = .red
            imageView.image = UIImage(systemName: "xmark.diamond.fill")?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .red
            imageView.isHidden = false
            activityIndicator.isHidden = true
        }
    }
}
