//
//  TableviewEX.swift
//  chat
//
//  Created by Fraol on 1/30/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
let cachestore = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    func loadcache(urlstring: String){
        
        // Gets rid of the glich when loading the profile pics of the users
        self.image = nil
        // checks if their is an image in the cache by using the key of the value on the object method
        if let cachedImage = cachestore.object(forKey: urlstring as AnyObject) as? UIImage{
            self.image = cachedImage
            //return
        }
       
        
        
        let url = URL(string: urlstring)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in

//        Prints out the error if their is one
            if error != nil {
                print(error as Any)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!){
                    //setting an object to the cache with its respective key
                    cachestore.setObject(downloadImage, forKey: urlstring as AnyObject)
                    self.image = downloadImage
                }
           }
        }.resume()
       
    }

}
