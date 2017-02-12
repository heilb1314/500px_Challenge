//
//  Errors.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/29/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import Foundation


public enum QueryPhotoError:Error {
    case failToParseJsonObject, photoNotFound, photoSizesCannotBeEmpty
}

public enum ImageObjectError:Error {
    case noUrlFound, noFormatFound, noSizeFound
}

public enum PhotoError:Error {
    case imageNotFound
}
