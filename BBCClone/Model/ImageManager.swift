//
//  ImageManager.swift
//  BBCClone
//
//  Created by Paing Zay on 27/9/23.
//

import Foundation
import UIKit

protocol ImageManagerDelegate {
    func didImageLoaded(_ imageManager: ImageManager, urlImage: UIImage)
    func didFailedWithError(error:Error)
}

struct ImageManager {
    
    var delegate: ImageManagerDelegate?

    func getImage(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                if let imageData = data {
                    if let urlimage = UIImage(data: imageData) {
                        self.delegate?.didImageLoaded(self, urlImage: urlimage)
                    }
                } else {
                    print("Error Loading Image")
                }
            }
            task.resume()
        }
    }
    
    
    //I tried to use the delegate method but it is super complex with callstacks, heavily impacted the performace and image displays are inaccurate
    func getRelatedNewsImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: imageUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                if let imageData = data {
                    if let urlImage = UIImage(data: imageData) {
                        completion(urlImage)
                    }
                } else {
                    print("Error Loading Image")
                }
            }
            task.resume()
        }
    }
}
