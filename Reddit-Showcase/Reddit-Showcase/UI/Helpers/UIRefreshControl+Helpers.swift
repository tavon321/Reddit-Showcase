//
//  UIRefreshControl+Helpers.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
