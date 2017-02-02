//
//  PhotoThumbnailCollectionViewCell.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/29/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoThumbnailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    internal var photo:Photo? {
        didSet {
            if photo != nil {
                let url = URL(string: photo!.images[0].url)
                thumbnailImageView.kf.setImage(with: url)
            }
        }
    }
    
}
