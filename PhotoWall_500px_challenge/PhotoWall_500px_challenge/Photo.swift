//
//  Photo.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/29/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import UIKit

/**
 * Photo Object with photo attributes and images information, Images cannot be nil
 */
public class Photo {
    public var name:String?
    public var description: String?
    public var images:[ImageObject]
    public var attributes:[String:Any]
    
    init(photoItem: [String:Any]) throws {
        images = [ImageObject]()
        attributes = [String:Any]()
        
        // iterate through key-val and parse them
        for(key,val) in photoItem {
            switch key {
            case PhotoFields.name:
                self.name = val as? String
            case PhotoFields.description:
                self.description = val as? String
            case PhotoFields.images:
                guard let imagesDic = val as? [[String:Any]] else { throw PhotoError.imageNotFound }
                try self.parseImages(imagesDic: imagesDic)
            default:
                attributes.updateValue(val, forKey: key)
            }
        }
        
        if self.images.isEmpty { throw PhotoError.imageNotFound }
    }
    
    
    /// Get Photo Size, if either width or height not found return 180X180
    public func getPhotoSize() -> CGSize {
        if let width = attributes[PhotoFields.width] as? Int {
            if let height = attributes[PhotoFields.height] as? Int {
                return CGSize(width: width, height: height)
            }
        }
        return CGSize(width: 180, height: 180)
    }

    
    /**
     * Parse images with images array, images cannot be empty.
     *
     * - Parameter imagesDic: images array gets from query json object photos
     */
    private func parseImages(imagesDic:[[String:Any]]) throws {
        for image in imagesDic {
            do {
                images.append(try ImageObject(imageDictionary: image))
            } catch {
                print("Fail to create Image Object: ", error.localizedDescription)
                continue
            }
        }
        if images.isEmpty { throw PhotoError.imageNotFound }
    }
    
    
    
    
    // MARK: - Class functions
    
    /**
     * Parse photos from json query object "photos".
     *
     * - Parameter dic: photos dictionary gets from query JSON object
     * - Returns: Photo array, can be nil
     */
    internal class func parsePhotos(withDictionary dic: [String:Any]) throws -> [Photo]? {
        if let photos = dic[QueryFields.photos] as? [Any] {
            var results = [Photo]()
            for item in photos {
                if let photoDic = item as? [String: Any] {
                    do {
                        results.append(try Photo(photoItem: photoDic))
                    } catch {
                        print("Fail parse photo: ", error)
                        continue;
                    }
                } else {
                    print("Not a dictionary.")
                }
            }
            
            return results
        }
        
        return nil
    }
    
}



/// Image Object using dictionary of Photos 'images' property
public class ImageObject {
    var url:String
    var format: String
    var size: Int
    
    init(imageDictionary dic: [String:Any]) throws {
        guard let url = dic[ImagesFields.url] as? String else { throw ImageObjectError.noUrlFound }
        guard let format = dic[ImagesFields.format] as? String else { throw ImageObjectError.noFormatFound }
        guard let size = dic[ImagesFields.size] as? Int else { throw ImageObjectError.noSizeFound }
        self.url = url
        self.format = format
        self.size = size
    }
}
