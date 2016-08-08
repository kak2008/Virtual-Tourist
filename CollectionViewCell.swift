//
//  CollectionViewCell.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 8/7/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func activityIndicatorAnimation(animate: Bool)
    {
        if animate == false {
            activityIndicator.stopAnimating()
            return
        }
        activityIndicator.startAnimating()
    }
}
