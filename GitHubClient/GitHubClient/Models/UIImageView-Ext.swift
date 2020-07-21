//
//  UIImageView-Ext.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 11.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()
class CustomImageView: UIImageView{
    var imageUrlString: String?
    func load(urlString: String){
        imageUrlString = urlString
        image = nil
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = image 
            return
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Couldn't create URL from String.")
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        
                        if self?.imageUrlString == urlString{
                            self?.image = image
                        }
                        imageCache.setObject(image, forKey: urlString as NSString)
                    }
                }
            }
            
        }
    }
}
