# Virtual-Tourist
This app allows users specify travel locations around the world, and create virtual photo albums for each location. The locations and photo albums will be stored in Core Data. Main focus of this application is to get deeper knowledge with Core Data, Image Persistance & NSOperations.

Flickr API has been used in order to fetch photos at different locations across the globe. 

This app allows user to drop pins on the map.
Users will then be able to download pictures for the location.
persist both the pictures, and the association of the pictures with the pin.


## Installation
In order to run this app. Download the repository, open it on XCode, build & run.


### Screenshots
![alt tag](https://github.com/kak2008/Virtual-Tourist/blob/master/Screenshots/virtual-Tourist%20screen%20shot.png)

## Implementation
This app has two view controllers:
- __Travel Location View Controller__: - This view controller shows the map and allows user to drop pins all over the world. Whenever user tap on dropped pin, photos are fetched from flickr at that particular location coordinates. User can delete pins in edit mode of this view controller.

- Photo Album View Controller: - This view controller 



## Requirements
* Xcode 7.3
* Swift 2.0

## License
Copyright (c) 2016 Anish Kodeboyina

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
