//
//  ParsingConstants.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/29/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import Foundation

/// Query fields
public struct QueryFields {
    static let totalItems = "total_items"
    static let photos = "photos"
    static let currentPage = "current_page"
    static let totalPages = "total_pages"
}


/// Photo fields in `QueryFields.photos`
public struct PhotoFields {
    static let aperture = "aperture"
    static let category = "category"
    static let collectionsCount = "collections_count"
    static let commentsCount = "comments_count"
    static let convertedBits = "converted_bits"
    static let description = "description"
    static let favoritesCount = "favorites_count"
    static let focalLength = "focal_length"
    static let forSaleDate = "for_sale_date"
    static let height = "height"
    static let highestRating = "highest_rating"
    static let hiResUploaded = "hi_res_uploaded"
    static let id = "id"
    static let imageFormat = "image_format"
    static let images = "images"
    static let imageUrl = "image_url"
    static let latitude = "latitude"
    static let licensingRequested = "licensing_requested"
    static let longitude = "longitude"
    static let name = "name"
    static let nsfw = "nsfw"
    static let privacy = "privacy"
    static let takenAt = "takenAt"
    static let timesViewed = "times_viewed"
    static let url = "url"
    static let user = "user"
    static let votesCount = "votes_count"
    static let width = "width"
}

/// Images fields in `PhotoFields.images`
public struct ImagesFields {
    static let format = "format"
    static let httpsUrl = "https_url"
    static let size = "size"
    static let url = "url"
}

public struct UserFields {
    static let city = "city"
    static let country = "country"
    static let firstname = "firstname"
    static let fullname = "fullname"
    static let id = "id"
    static let lastname = "lastname"
    static let username = "username"
    static let userpicUrl = "userpic_url"
}


let CATEGORIES = [
    "Popular",
    "Upcoming",
    "Uncategorized",
    "Abstract",
    "Animals",
    "Black and White",
    "Celebrities",
    "City and Architecture",
    "Commercial",
    "Concert",
    "Family",
    "Fashion",
    "Film",
    "Fine Art",
    "Food",
    "Journalism",
    "Landscapes",
    "Macro",
    "Nature",
    "Nude",
    "People",
    "Performing Arts",
    "Sport",
    "Still Life",
    "Street",
    "Transportation",
    "Travel",
    "Underwater",
    "Urban Exploration",
    "Wedding"
]

