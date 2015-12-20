//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import NYTPhotoViewer

/**
*   In Swift 1.2, the following file level constants can be moved inside the class for better encapsulation
*/
//let CustomEverythingPhotoIndex = 1, DefaultLoadingSpinnerPhotoIndex = 3, NoReferenceViewPhotoIndex = 4
let PrimaryImageName = "NYTimesBuilding"
let PlaceholderImageName = "NYTimesBuildingPlaceholder"

class PhotosProvider: NSObject {
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImageForPhoto(url: NSURL, str: NSAttributedString) -> ExamplePhoto{
        let photo = ExamplePhoto(imageData: nil, attributedCaptionTitle: str)
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                photo.image = UIImage(data: data)
            }
        }
        return photo
    }
    
    func getImages(imageUrls: [String]) -> [ExamplePhoto] {
        var mutablePhotos: [ExamplePhoto] = []
        var image: UIImage!
        let NumberOfPhotos = imageUrls.count
        
        func shouldSetImageOnIndex(photoIndex: Int) -> Bool {
            return false
            //            return photoIndex != CustomEverythingPhotoIndex && photoIndex != DefaultLoadingSpinnerPhotoIndex
        }
        
        for photoIndex in 0 ..< imageUrls.count {
            let title = NSAttributedString(string: "\(photoIndex + 1)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            
            let url = NSURL(string: imageUrls[photoIndex])!
            
            //            let photo = ExamplePhoto(imageData: UIImagePNGRepresentation(image!))
            
            mutablePhotos.append(downloadImageForPhoto(url, str: title))
        }
        
        return mutablePhotos
    }
    
    let photos: [ExamplePhoto] = {
        
        var mutablePhotos: [ExamplePhoto] = []
        var image = UIImage(named: PrimaryImageName)
        let NumberOfPhotos = 5
        
        func shouldSetImageOnIndex(photoIndex: Int) -> Bool {
            //            return photoIndex != CustomEverythingPhotoIndex && photoIndex != DefaultLoadingSpinnerPhotoIndex
            return false
        }
        
        for photoIndex in 0 ..< NumberOfPhotos {
            let title = NSAttributedString(string: /*"\(photoIndex + 1)"*/" ", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            let photo = shouldSetImageOnIndex(photoIndex) ? ExamplePhoto(imageData: UIImagePNGRepresentation(image!), attributedCaptionTitle: title) : ExamplePhoto(attributedCaptionTitle: title)
            
            //            if photoIndex == CustomEverythingPhotoIndex {
            //                photo.placeholderImage = UIImage(named: PlaceholderImageName)
            //            }
            
            mutablePhotos.append(photo)
        }
        
        return mutablePhotos
    }()    
}
