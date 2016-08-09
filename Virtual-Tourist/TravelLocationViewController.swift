//
//  TravelLocationViewController.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 7/17/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit
import MapKit
import CoreData

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
        
        fetchSavedAnnotations()
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
            
            // Create Annotation Calling
            createAnnotation(myMapPoint)
          
            // Core Data Calling
            saveAnnotationCoordinates(myMapPoint)
        }
    }
    
    /** Create Annotation onto the Map Viewer */
    func createAnnotation(myMapPoint: CLLocationCoordinate2D)
    {
        // annotation creation
        let anno = MKPointAnnotation()
        anno.coordinate = myMapPoint
        
        // Adding annotation to map
        TLVCMapViewer.addAnnotation(anno)
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        selectedAnnotation = view.annotation
        tappedLocationCoordinates = view.annotation?.coordinate
        
        // [mapView deselectAnnotation:annotation animated:NO];
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        if editMode == false
        {
            performSegueWithIdentifier("MapViewToPhotoAlbumVCSegueID", sender: self)
        }
        else
        {
            createAlertWithMessage("Delete", Message: "Delete this annotation..?", actionTitle: "Delete", deleteAll: false)
        }
    }
    
    /** Deletes All Annotations from MapViewer and CoreData */
    func deleteAllAnnotations()
    {
        let allAnnotations = TLVCMapViewer.annotations
        TLVCMapViewer.removeAnnotations(allAnnotations)
        deleteAllAnnotationsFromCoreData()
    }
    
    /** Deletes Selected Annotation from MapViewer and CoreData */
    func deleteSelectedAnnotation()
    {
        TLVCMapViewer.removeAnnotation(selectedAnnotation)
        deleteSelectedAnnotaionFromCoreData(selectedAnnotation.coordinate)
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
    
    /** Enable and Disable the UI Elements */
    func enableAndDisableElements(doneValue: Bool, editValue:Bool, deleteValue: Bool)
    {
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
    

    // MARK: - Core Data 
    
    /** Saving Annotation information into Core Data */
    func saveAnnotationCoordinates(annotationCoordinates: CLLocationCoordinate2D)
    {
        
      let appDelegateobj = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObj = appDelegateobj.managedObjectContext
        
        let entityObj = NSEntityDescription.entityForName("Annotations", inManagedObjectContext: managedObj)
        
        let row = NSManagedObject(entity: entityObj!, insertIntoManagedObjectContext: managedObj)
        
        row.setValue(annotationCoordinates.latitude, forKey: "latitude")
        row.setValue(annotationCoordinates.longitude, forKey: "longitude")
                
        do {
            try managedObj.save()
        }
        catch let error as NSError {
            // error handling...
            let errorMsg = error.localizedDescription
            showAlertWithOkAction("Error", Message: errorMsg)
        }
    }
    
    
    /** fetching Annotation information from Core Data */
    func fetchSavedAnnotations()
    {
        let appDelegateobj = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObj = appDelegateobj.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Annotations")
        
        do{
            let fetchRequestResults = try managedObj.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        
            for item in fetchRequestResults {
                
                let lat = item.valueForKey("latitude")! as! CLLocationDegrees
                let long = item.valueForKey("longitude")! as! CLLocationDegrees
                
                let coord: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
                
                // Create annotations on map
                createAnnotation(coord)
            }
        }
        catch let error as NSError
        {
            // error handling...
            let errorMsg = error.localizedDescription
            showAlertWithOkAction("Error", Message: errorMsg)
        }
    }
    
    
    /** Delete Annotation from Core Data */
    func deleteSelectedAnnotaionFromCoreData(deleteAnnoCoordinates: CLLocationCoordinate2D)
    {
        let appDelegateobj = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObj = appDelegateobj.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Annotations")
        
        do{
            let fetchRequestResults = try managedObj.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for item in fetchRequestResults {
                
                let lat = item.valueForKey("latitude")! as! CLLocationDegrees
                let long = item.valueForKey("longitude")! as! CLLocationDegrees
                
                // Compare coordinates
                if (lat == deleteAnnoCoordinates.latitude && long == deleteAnnoCoordinates.longitude)
                {
                    // Delete annotation coordinate
                    managedObj.deleteObject(item)
                }
            }
            // Save data
            try managedObj.save()
        }
        catch let error as NSError
        {
            // error handling...
            let errorMsg = error.localizedDescription
            showAlertWithOkAction("Error", Message: errorMsg)
        }
    }

    
    /** Delete All annotations from Core Data */
    func deleteAllAnnotationsFromCoreData()
    {
        let appDelegateobj = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObj = appDelegateobj.managedObjectContext

        let fetchRequest = NSFetchRequest(entityName: "Annotations")
        
        let deleteReq = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try managedObj.executeRequest(deleteReq)
            try managedObj.save()
        }
        catch let error as NSError
        {
            // error handling...
            let errorMsg = error.localizedDescription
            showAlertWithOkAction("Error", Message: errorMsg)
        }
    }
}

