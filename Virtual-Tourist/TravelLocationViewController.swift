//
//  TravelLocationViewController.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 7/17/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationViewController: UIViewController, MKMapViewDelegate
{
    var tappedLocationCoordinates: CLLocationCoordinate2D! = nil
    
    @IBOutlet weak var TLVCMapViewer: MKMapView!
  
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TLVCMapViewer.delegate = self
        longPressGesture()
    }
    
    
    // MARK: - Map Gesture Annotation Methods
    
    func longPressGesture()
    {
        let longPG = UILongPressGestureRecognizer(target: self, action: #selector(TravelLocationViewController.longPressAction))
        longPG.minimumPressDuration = 2
        
        TLVCMapViewer.addGestureRecognizer(longPG)
        
    }
    
    func longPressAction(myLongPress: UILongPressGestureRecognizer)
    {
        // Get the location
        let myCGPoint = myLongPress.locationInView(TLVCMapViewer)
        let myMapPoint = TLVCMapViewer.convertPoint(myCGPoint, toCoordinateFromView: TLVCMapViewer)
       // print(myMapPoint)
        
        // Create Annotation
        let anno =  MKPointAnnotation()
        anno.coordinate = myMapPoint
        
        TLVCMapViewer.addAnnotation(anno)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
       // print("Annotation Pressed : \(view.annotation?.coordinate)")
        tappedLocationCoordinates = view.annotation?.coordinate
       // print(coord)
        performSegueWithIdentifier("MapViewToPhotoAlbumVCSegueID", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let VC = segue.destinationViewController as! PhotoAlbumViewController
        VC.selectedAnnotationCoordinates = tappedLocationCoordinates
    }
}





