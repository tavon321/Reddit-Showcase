//
//  ExpandedImageController.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit
import WebKit

class ExpandedImageController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    public var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
}
