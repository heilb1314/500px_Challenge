//
//  QueryModel.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/27/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import Foundation
import Alamofire
//import PXAPI

class QueryModel {
    
    static let consumerKey = "V48YYid7RwaujUL5pZOJ6rAJfGDkFxbsG0g3Bw8O"
    
    /**
     * Query photos with specific term, page, results per page, and photo sizes
     * - Parameters:
     *      - term: A
     */
    class func getPhotos(forSearchTerm term: String, page: Int, resultsPerPage counts: Int = 12, photoSizes: [Int], callback:@escaping ([Photo]?,Error?)->()) {
        guard !photoSizes.isEmpty else {
            callback(nil, QueryPhotoError.photoSizesCannotBeEmpty)
            return
        }
        let headers = [
            "consumer_key":consumerKey,
            "term":term,
            "page":String(page),
            "rpp":String(counts),
            "image_size[]":photoSizes.map{"\($0)"}.joined(separator: ",")
        ]
        
        
        Alamofire.request("https://api.500px.com/v1/photos/search", method: .get, parameters: headers, encoding: URLEncoding.default, headers: nil).responseJSON { (results) in
            if let dict = results.result.value as? [String:Any] {
                do {
                    // Parse Photos
                    guard let photos = try Photo.parsePhotos(withDictionary: dict) else {
                        return callback(nil, QueryPhotoError.photoNotFound)
                    }

                    callback(photos, nil)
                } catch {
                    callback(nil, error)
                }
            } else if results.error != nil {
                return callback(nil, results.error)
            } else {
                return callback(nil, QueryPhotoError.failToParseJsonObject)
            }
        }
    }
}



