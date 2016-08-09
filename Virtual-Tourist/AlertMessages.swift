//
//  AlertMessages.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 8/8/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import Foundation
import UIKit

extension TravelLocationViewController
{
    func showAlertWithOkAction(Title: String, Message: String)
    {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))

            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

