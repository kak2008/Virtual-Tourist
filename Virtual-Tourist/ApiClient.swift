//
//  ApiClient.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 8/3/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import MapKit

class ApiClient: NSObject
{
    struct Constants {
        static let APIKey   = "d977235eef395478a4e1c97eb9e749a4"
        static let BASE_URL = "https://api.flickr.com/services/rest/"
    }
    
    func getPhotos(selectedAnnoCoordinates: CLLocationCoordinate2D, failure: (errorMessage: String) -> Void, success: () -> Void)
    {
        let url = "\(Constants.BASE_URL)?method=flickr.photos.search&api_key=\(Constants.APIKey)&sort=&lat=\(selectedAnnoCoordinates.latitude)&lon=\(selectedAnnoCoordinates.longitude)&per_page=20&page=1&format=json&nojsoncallback=1"
        
        let urlObj: NSURL = NSURL(string: url)!
        
        let request = NSURLRequest(URL: urlObj)
        
        // URL Request session
        
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: conf)
        
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // error handling
            if(error != nil)
            {
                // REVIEW: What happens in this case?
              
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
                
                success()
            }
                
            catch
            {
           //     print("Unable to parse the response data!");
                
                // REVIEW: What happens in this case?
            }
           
        }
        
       task.resume()
    
    }
    
    func getActualPhotoData(farmID: String!, serverID: String!, id: String!, secret: String!, result: (imageData: NSData) -> Void)
    {
        //REVIEW: Instead of getting seperate parametes, get a dictionary and extract all values in this method
        
        let urlString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
        
        let url = NSURL(string: urlString)
        
        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: conf)
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            if error != nil{
                
                // REVIEW: Handle this case
                
          //      print("error \(error)")
                return
            }
            
            result(imageData: data!)
        }
        task.resume()
    }

}
