//
//  ApiClient.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 8/3/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit

class ApiClient: NSObject
{
    
    func getPhotos(failure: (errorMessage: String) -> Void, success: () -> Void)
    {
        // URL Request creation
        
        let url =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=78dbbb1a5b2b8703990a2ae27ad4807c&lat=38.889931&lon=-77.009003&per_page=10&page=1&format=json&nojsoncallback=1&auth_token=72157669072556973-2e7dba9faf0c1d55&api_sig=86254a0efd30388c3e7ac1db639cdccb"
        
        
        let urlObj: NSURL = NSURL(string: url)!
        
        let request = NSURLRequest(URL: urlObj)
        
        
        // URL Request session
        
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: conf)
        
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // error handling
            if(error != nil)
            {
                print(error)
                return
            }
     
            do{
                // Data conversion: NSDATA to JSON
                let receivedData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                
                let userPhotosArray = receivedData["photos"] as! NSDictionary!
                
                let userPhotodetails = userPhotosArray["photo"] as! NSArray!
                
                
                let obj = UsersPhotosInfo.userPhotosSharedInstance
                obj.userPhotosDic = userPhotosArray as NSDictionary!
                obj.userPhotoDetailsArray = userPhotodetails as NSArray!
                

                print(obj.userPhotoDetailsArray)
                success()
            }
                
            catch
            {
                print("Unable to parse the response data!");
            }
           
        }
        
       task.resume()
    
    }
    
    func getActualPhotoData(farmID: String!, serverID: String!, id: String!, secret: String!, result: (imageData: NSData) -> Void)
    {
        // url request
        
        
        let url = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
        
        let nsURL = NSURL(string: url)
        
        // url request
        
    //    let request = NSURLRequest(URL: nsURL!)
        
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: conf)
        
        let task = session.dataTaskWithURL(nsURL!) { (data, response, error) in
            if error != nil{
                print("error \(error)")
                return
            }
         //   print("success")
            result(imageData: data!)
        }
        task.resume()
    }
    
    
    
    //flickr api key
//    d977235eef395478a4e1c97eb9e749a4
//    
//    Secret:
//    a98d5aa4d0c41701
}
