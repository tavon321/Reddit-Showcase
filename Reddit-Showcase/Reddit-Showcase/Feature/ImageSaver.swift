//
//  ImageSaver.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import Foundation

public protocol ImageSaver {
    typealias Result = Error?
    
    func save(_ data: Data, completion: @escaping (Result) -> Void)
}
