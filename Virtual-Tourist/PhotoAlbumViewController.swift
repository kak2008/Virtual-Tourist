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
    
    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var editBarButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonOutlet: UIBarButtonItem!
    
    var editMode: Bool! = false
    var noImagesLabel: UILabel!
    var selectedAnnotationCoordinates: CLLocationCoordinate2D! = nil
    
    var checkImageBox: UIImageView!
    var selectedIndexPath: NSIndexPath!
    
    
    //  MARK:- View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "World Map"

        collectionView.dataSource = self
        collectionView.delegate = self
        
        zoomToRegion()
        getPhotosCalling()
        createImagesLabel()
        enableDisableBarButtons(true, doneValue: false, deleteValue: false)
     }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        noImagesLabel.center = collectionView.center
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
   
    //  MARK:- Zoom to Annotation region
    /** zoom to the region selected on the map */
    func zoomToRegion()
    {
        let location = selectedAnnotationCoordinates
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        PAVCMapViewer.setRegion(region, animated: true)
        createAnnotation(location)
    }
    
   
    //  MARK:- Enable/Disable UI Elements
    /** Enables/Disables edit, Done, Delete Bar Buttons with respective bool value */
    func enableDisableBarButtons(editValue: Bool, doneValue: Bool, deleteValue: Bool)
    {
        editBarButtonOutlet.enabled = editValue
        doneButtonOutlet.enabled = doneValue
        deleteBarButtonOutlet.enabled = deleteValue
    }
    
    
    // MARK: - Create Alert with Message and respective action
    
    /** Create alert with Message & delete action. */
    func createAlertWithMessage(Title: String, Message: String, actionTitle: String, deleteAll: Bool)
    {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: actionTitle, style: .Destructive, handler: { (ACTION:UIAlertAction!) in
            if(deleteAll == true)
            {
                UsersPhotosInfo.userPhotosSharedInstance.userPhotoDetailsArray.removeAllObjects()
                self.collectionView.reloadData()
            }
            else
            {
                UsersPhotosInfo.userPhotosSharedInstance.userPhotoDetailsArray.removeObjectAtIndex(self.selectedIndexPath.row)
                self.collectionView.deleteItemsAtIndexPaths([self.selectedIndexPath])
                self.collectionView.reloadData()
            }
        }))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
        
        noImagesLabel.hidden = (userPhotosObj.userPhotoDetailsArray != nil) && (userPhotosObj.userPhotoDetailsArray.count > 0)
        
        if userPhotosObj.userPhotoDetailsArray == nil
        {
            return 0
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


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(((collectionView.bounds.size.width/3)-10), CGFloat((collectionView.bounds.size.width/3)-10))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedIndexPath = indexPath
        if editMode == true
        {
            createAlertWithMessage("Delete", Message: "Do you want to delete this image...?", actionTitle: "Delete", deleteAll: false)
        }
    }

    
    //  MARK:- Show No Images Label
    /** Shows No Image Label on the Collection View */
    func createImagesLabel()
    {
        noImagesLabel = UILabel(frame: CGRectMake(0, 0, collectionView.frame.width, 21))
        noImagesLabel.textAlignment = NSTextAlignment.Center
        noImagesLabel.text = "No images"
        noImagesLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(noImagesLabel)
    }
    
   
    //  MARK:- New Collection Button Action methods
    
    @IBAction func newCollectionButtonPressed(sender: AnyObject)
    {
        getPhotosCalling()
    }
    
    @IBAction func editBarButtonPressed(sender: AnyObject) {
        enableDisableBarButtons(false, doneValue: true, deleteValue: true)
        editMode = true
    }
    
    @IBAction func deleteBarButtonPressed(sender: AnyObject) {
        // delete All cells
        createAlertWithMessage("Delete All", Message: "Are you sure, you wanna delete all cells...?", actionTitle: "Delete All", deleteAll: true)
    }
    
    @IBAction func doneBarButtonPressed(sender: AnyObject) {
        enableDisableBarButtons(true, doneValue: false, deleteValue: false)
        editMode = false
    }

    @IBAction func backBarButtonPressed(sender: AnyObject) {
     self.navigationController?.popViewControllerAnimated(true)
    }
  
}
