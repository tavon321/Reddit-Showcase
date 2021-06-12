//
//  UIView+Helpers.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

extension UIView {
    func addTapGesture(action: Selector?, target: Any) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapGesture)
    }
}

// Code from https://medium.com/@tate.pravin/swift-uiview-tapping-animation-extension-1f9a188b53b6
public extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
                       }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                           }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
                       }
    }
}
