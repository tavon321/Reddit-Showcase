//
//  guaranteeMainThread.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 11/06/21.
//

import Foundation

func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
