//
//  PhotoDetailViewController.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 1/29/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var textView: UITextView!
    
    internal var photo: Photo!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhotoDetail()
        let url = URL(string: photo.images[photo.images.count - 1].url)
        imageView.kf.setImage(with: url)
        
        self.imageView.isUserInteractionEnabled = true
        setupTapGestures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.tintColor = Color.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.white]
        self.navigationItem.title = photo.name
    }
    
    private func setupPhotoDetail() {
        var detail = ""
        detail += "Name: " + (photo.name ?? "") + "\n"
        if let user = photo.attributes[PhotoFields.user] as? [String:Any] {
            detail += "User: " + (user[UserFields.fullname] as? String ?? (user[UserFields.username] as? String) ?? "") + "\n"
        }
        if let fav = photo.attributes[PhotoFields.favoritesCount] as? Int {
            detail += "Favored: " + fav.description + "\n"
        }
        if let viewed = photo.attributes[PhotoFields.timesViewed] as? Int {
            detail += "Viewed: " + viewed.description + "\n"
        }
        detail += "Description: " + (photo.description ?? "") + "\n"
        
        
        self.textView.text = detail
    }
    
    private func setupTapGestures() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleDetail))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleImageSize))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        singleTapGestureRecognizer.delegate = self
        doubleTapGestureRecognizer.delegate = self
        self.imageView.addGestureRecognizer(singleTapGestureRecognizer)
        self.imageView.addGestureRecognizer(doubleTapGestureRecognizer)
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
    }
    
    /// hide/show detail and nav bar when tap once
    func toggleDetail(gest: UITapGestureRecognizer) {
        self.blurView.isHidden = !self.blurView.isHidden
        self.navigationController?.navigationBar.isHidden = self.blurView.isHidden
    }
    
    // toggle imageView aspectFit/aspectFill when tap twice
    func toggleImageSize(gest: UITapGestureRecognizer) {
        if self.imageView.contentMode == .scaleAspectFit {
            self.imageView.contentMode = .scaleAspectFill
        } else {
            self.imageView.contentMode = .scaleAspectFit
        }
    }

    
}
