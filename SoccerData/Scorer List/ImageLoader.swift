//
//  ImageLoader.swift
//  SoccerData
//
//  Created by Alfian Losari on 05/12/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import SVGKit

class ImageLoader: ObservableObject {
    
    private static let imageCache = NSCache<AnyObject, AnyObject>()
    
    @Published var image: UIImage? = nil
    
    init(teamId: Int? = nil) {
        if let imageFromCache = ImageLoader.imageCache.object(forKey: teamId as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }        
    }
    
    
    public func downloadImage(url: URL, teamId: Int) {
        if let imageFromCache = ImageLoader.imageCache.object(forKey: teamId as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
    
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            guard let data = data else {
                return
            }
            
            var image: UIImage?
            if url.absoluteString.hasSuffix("svg") {
                image = SVGKImage(data: data)?.uiImage
            } else {
                image = UIImage(data: data)
            }
            
            guard let finalImage = image else { return }
            
            DispatchQueue.main.async { [weak self] in
                ImageLoader.imageCache.setObject(finalImage, forKey: teamId  as AnyObject)
                self?.image = image
            }
        }.resume()
    }
}
