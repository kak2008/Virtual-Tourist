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
    
    var selectedAnnotationCoordinates: CLLocationCoordinate2D! = nil
    
    
    //  MARK:- View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "World Map"

        zoomToRegion()
       
        collectionView.dataSource = self
        collectionView.delegate = self

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
    
    
    //  MARK:- Collection view cell methods
    

    // Number of section in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of Items in section in collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor .whiteColor()
      
        let imageView = cell.viewWithTag(10) as! UIImageView
        imageView.image = UIImage(named: "No-Image-Basic.png")
        
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(((collectionView.bounds.size.width/3)-10), CGFloat((collectionView.bounds.size.width/3)-10))
    }
    
    
}
