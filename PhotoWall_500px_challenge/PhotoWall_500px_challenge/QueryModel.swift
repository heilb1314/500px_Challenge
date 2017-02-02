//
//  QueryModel.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/27/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import Foundation
import PXAPI

class QueryModel {
    
    /**
     * Query photos with specific term, page, results per page, and photo sizes
     * - Parameters:
     *      - term: A
     */
    class func getPhotos(forSearchTerm term: String, page: Int, resultsPerPage counts: Int = 12, photoSizes: PXPhotoModelSize, callback:@escaping ([Photo]?,Error?)->()) {
        
        let _ = PXRequest(forSearchTerm: term, page: UInt(page), resultsPerPage: UInt(counts), photoSizes: photoSizes) { (results, error) in
            if(results != nil) {
                do {
                    // Parse JSON
                    guard let dic = try JSONSerialization.jsonObject(with: results!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                        return callback(nil, QueryPhotoError.failToParseJsonObject)
                    }
                    
                    // Parse Photos
                    guard let photos = try Photo.parsePhotos(withDictionary: dic) else {
                        return callback(nil, QueryPhotoError.photoNotFound)
                    }
                    
                    callback(photos, nil)
                } catch {
                    callback(nil, error)
                }
            } else {
                callback(nil, error)
            }
        }
    }
}



