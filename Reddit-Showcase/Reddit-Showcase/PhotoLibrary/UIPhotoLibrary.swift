//
//  UIPhotoLibrary.swift
//  Reddit-Showcase
//
//  Created by Gustavo on 12/06/21.
//

import UIKit

class UIPhotoLibrary: NSObject, PhotoLibrary {
    private var completion: ((PhotoLibrary.Result) -> Void)?
    
    func save(_ image: UIImage, completion: @escaping (PhotoLibrary.Result) -> Void) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        self.completion = completion
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion?(error)
    }
}
