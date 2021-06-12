//
//  ImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

public protocol ImageSaver {
    typealias Result = Error?
    
    func save(_ image: UIImage, completion: @escaping (Result) -> Void)
}
