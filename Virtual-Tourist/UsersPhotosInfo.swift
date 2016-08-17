//
//  UsersPhotosInfo.swift
//  Virtual-Tourist
//
//  Created by Vasanth Kodeboyina on 8/5/16.
//  Copyright © 2016 Anish Kodeboyina. All rights reserved.
//

import UIKit

class UsersPhotosInfo: NSObject {
    static let userPhotosSharedInstance = UsersPhotosInfo()

    var userPhotosDic: NSDictionary!
    var userPhotoDetailsArray: NSMutableArray!
}
