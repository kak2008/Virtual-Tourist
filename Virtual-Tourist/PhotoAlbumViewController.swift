//
//  PhotoAlbumViewController.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 7/17/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var PAVCMapViewer: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newCollectionButtonOutlet: UIBarButtonItem!
    
    var selectedAnnotationCoordinates: CLLocationCoordinate2D! = nil
    
    //  MARK:- View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "World Map"

        zoomToRegion()
       
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getPhotosCalling()
 
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //  MARK:- Zoom to Annotation region
    
    func zoomToRegion()
    {
        let location = selectedAnnotationCoordinates
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        PAVCMapViewer.setRegion(region, animated: true)
        createAnnotation(location)
    }
    

    //  MARK:- Create Annotation with location coordinates

    func createAnnotation(location: CLLocationCoordinate2D)
    {
        // Create Annotation
        let anno =  MKPointAnnotation()
        anno.coordinate = location
        
        PAVCMapViewer.addAnnotation(anno)
    }
    
    
    func getPhotosCalling()
    {
        newCollectionButtonOutlet.enabled = false
        
        let urlCalling = ApiClient()
        urlCalling.getPhotos(selectedAnnotationCoordinates, failure: { (errorMessage) in
            // failure Case
            
            }) { 
                // Success Case
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.reloadData()
                    self.newCollectionButtonOutlet.enabled = true
                })
        }
    }
    
    
    //  MARK:- Collection view cell methods
    
    // Number of section in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of Items in section in collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userPhotosObj = UsersPhotosInfo.userPhotosSharedInstance
        
        if userPhotosObj.userPhotoDetailsArray == nil
        {
            return 0
        }
        else
            if userPhotosObj.userPhotoDetailsArray.count == 0
            {
                showNoImagesLabel()
            }

        return userPhotosObj.userPhotoDetailsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor .whiteColor()
        
        let userPhotosObj = UsersPhotosInfo.userPhotosSharedInstance
        let photoDictionary = (userPhotosObj.userPhotoDetailsArray[indexPath.row])
        
        let farmID = photoDictionary["farm"] as! NSNumber
        let serverID = photoDictionary["server"] as! String
        let id = photoDictionary["id"] as! String
        let secret = photoDictionary["secret"] as! String
        
        let imageView = cell.viewWithTag(10) as! UIImageView
        
        let apiClientObj = ApiClient()
        apiClientObj.getActualPhotoData("\(farmID)", serverID: serverID, id: "\(id)", secret: secret) { (imageData) in
            // Activity indicator Animation
            dispatch_async(dispatch_get_main_queue(), { 
                cell.activityIndicatorAnimation(false)
            })
            
            // if result is nil
            if imageData != ""
            {
               dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = UIImage(data: imageData)
               })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { 
                    imageView.image = UIImage(named: "No-Image-Basic.png")
                })
            }
        }
        
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        
        return cell
    }

    func showNoImagesLabel()
    {
        let label = UILabel(frame: CGRectMake(0, 0, collectionView.frame.width, 21))
        label.center = collectionView.center
        label.textAlignment = NSTextAlignment.Center
        label.text = "No images"
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(((collectionView.bounds.size.width/3)-10), CGFloat((collectionView.bounds.size.width/3)-10))
    }
    
    //  MARK:- New Collection Button Action methods
    
    @IBAction func newCollectionButtonPressed(sender: AnyObject)
    {
        getPhotosCalling()
    }

    
}
