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

    @IBOutlet weak var doneBarButtonItemOutlet: UIBarButtonItem!
    @IBOutlet weak var editBarButtonItemOutlet: UIBarButtonItem!
    @IBOutlet weak var deleteBarButtonItemOutlet: UIBarButtonItem!
    
    @IBOutlet weak var TLVCMapViewer: MKMapView!
  
    var editMode: Bool! = false
    var selectedAnnotation: MKAnnotation!
    
   
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        TLVCMapViewer.delegate = self
        longPressGesture()
        doneBarButtonItemOutlet.enabled = false
        enableAndDisableElements(false, editValue: true, deleteValue: false)
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
        // Check state of Long Gesture
        
        if myLongPress.state == .Began
        {
            // Get the location
            let myCGPoint = myLongPress.locationInView(TLVCMapViewer)
            let myMapPoint = TLVCMapViewer.convertPoint(myCGPoint, toCoordinateFromView: TLVCMapViewer)
            
            if editMode == true {
                createAlertWithMessage("Edit Mode", Message: "Cannot create annotation in Edit Mode", actionTitle: "Ok", deleteAll: false)
                return
            }
            
            // Create Annotation
            let anno =  MKPointAnnotation()
            anno.coordinate = myMapPoint
            
            TLVCMapViewer.addAnnotation(anno)
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        selectedAnnotation = view.annotation
        tappedLocationCoordinates = view.annotation?.coordinate
        if editMode == false
        {
            performSegueWithIdentifier("MapViewToPhotoAlbumVCSegueID", sender: nil)
        }
        else
        {
            createAlertWithMessage("Delete", Message: "Delete this annotation..?", actionTitle: "Delete", deleteAll: false)
        }
    }
    
    // Delete All Annotations
    func deleteAllAnnotations()
    {
        let allAnnotations = TLVCMapViewer.annotations
        TLVCMapViewer.removeAnnotations(allAnnotations)
    }
    
    // Delete Selected Annotation
    func deleteSelectedAnnotation()
    {
        TLVCMapViewer.removeAnnotation(selectedAnnotation)
    }

    
    // MARK: - Create Alert with Message and respective action

    func createAlertWithMessage(Title: String, Message: String, actionTitle: String, deleteAll: Bool) -> Void {
        // alert with Yes action
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: actionTitle, style: .Destructive, handler: { (ACTION:UIAlertAction!) in
            if(deleteAll == true)
            {
                self.deleteAllAnnotations()
            }
            else
            {
                self.deleteSelectedAnnotation()
            }
        }))
        dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Enable or Disable UI Elements

    func enableAndDisableElements(doneValue: Bool, editValue:Bool, deleteValue: Bool) -> Void {
        doneBarButtonItemOutlet.enabled = doneValue
        editBarButtonItemOutlet.enabled = editValue
        deleteBarButtonItemOutlet.enabled = deleteValue
    }
    

    // MARK: - UI Bar Button Item Actions
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        enableAndDisableElements(true, editValue: false, deleteValue: true)
        editMode = true
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        enableAndDisableElements(false, editValue: true, deleteValue: false)
        editMode = false
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        // Delete selected annotation pins
        createAlertWithMessage("Delete", Message: "Do you want to delete all annotations...?", actionTitle: "Yes", deleteAll: true)
    }
    
    
    // MARK: - Navigation Methods (Segue)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if editMode == false
        {
            let VC = segue.destinationViewController as! PhotoAlbumViewController
            VC.selectedAnnotationCoordinates = tappedLocationCoordinates
        }
       
    }
}





