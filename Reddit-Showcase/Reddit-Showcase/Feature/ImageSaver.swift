//
//  ImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

protocol ImageSaver {
    typealias Result = Swift.Result<UIImage, Error>
    
    func save(_ image: UIImage, completion: @escaping (Result) -> Void)
}
