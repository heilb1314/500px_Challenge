//
//  PhotoWallViewController.swift
//  PhotoWall_500px_challenge
//
//  Created by Jianxiong Wang on 2/1/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import UIKit

class PhotoWallViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    fileprivate var photos:[Photo]!
    fileprivate var gridSizes: [CGSize]!
    fileprivate var itemsPerRow: Int = 3
    fileprivate var lastViewdIndexPath: IndexPath?
    fileprivate var isLandscape = false
    fileprivate var isLoading = false
    fileprivate var searchController: UISearchController!
    fileprivate var searchTerm: String = CATEGORIES[0]
    fileprivate var page: Int = 1
    
    
    private var pageSize: Int = 30
    private var photoSizes: [Int] = [3,4]
    private var selectedIndex: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.titleTextAttributes = nil
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeTerm(sender:)))
        rightBarItem.tintColor = UIColor.orange
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.title = searchTerm.capitalized
        self.updateCollectionViewLayout()
    }
    
    func changeTerm(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showCategories", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLandscape = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        
        if let layout = collectionView?.collectionViewLayout as? PhotoWallLayout {
            layout.delegate = self
        }
        
        self.photos = [Photo]()
        getPhotos(resetPhotos: true, completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Get next page Photos. Auto reload collectionView.
    fileprivate func getPhotos(resetPhotos: Bool, completionHandler handler: (()->())?) {
        QueryModel.getPhotos(forSearchTerm: searchTerm, page: page, resultsPerPage: pageSize, photoSizes: photoSizes) { (photos, error) in
            if(photos != nil) {
                self.page += 1
                resetPhotos ? self.photos = photos : self.photos.append(contentsOf: photos!)
                self.collectionView.layoutIfNeeded()
                self.collectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            handler?()
        }
    }
    
    /// update collectionView layout and move to last viewed indexPath if any.
    fileprivate func updateCollectionViewLayout() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        let curOrientation = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        if self.lastViewdIndexPath != nil && self.isLandscape != curOrientation {
            self.isLandscape = curOrientation
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: self.lastViewdIndexPath!, at: curOrientation ? .right : .bottom, animated: false)
            }
        }
    }
    
    // MARK: - UIScrollView Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lastViewdIndexPath = self.collectionView.indexPathsForVisibleItems.last
        
        // load next page when scrollView reaches the end
        guard self.isLoading == false else { return }
        var offset:CGFloat = 0
        var sizeLength:CGFloat = 0
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            offset = scrollView.contentOffset.x
            sizeLength = scrollView.contentSize.width - scrollView.frame.size.width
        } else {
            offset = scrollView.contentOffset.y
            sizeLength = scrollView.contentSize.height - scrollView.frame.size.height
        }
        if offset >= sizeLength {
            self.isLoading = true
            self.getPhotos(resetPhotos: false, completionHandler: {
                self.isLoading = false
            })
        }
    }
    
    // MARK: - UICollectionView DataSources
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoThumbnailCollectionViewCell
        
        cell.photo = self.photos?[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - UICollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "showPhotoDetail", sender: self)
    }
    
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoDetail" {
            let svc = segue.destination as! PhotoDetailViewController
            if self.photos != nil && self.selectedIndex != nil && self.selectedIndex! < self.photos!.count {
                svc.photo = self.photos![self.selectedIndex!]
            }
        } else if segue.identifier == "showCategories" {
            let svc = segue.destination as! SearchTermTableViewController
            svc.delegate = self
        }
    }
}

// MARK: Extension - PhotoWallLayoutDelegate

extension PhotoWallViewController: PhotoWallLayoutDelegate {
    func collectionView(collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return photos[indexPath.item].getPhotoSize()
    }
    
    // Update grids when device rotates
    override func viewWillLayoutSubviews() {
        if self.isLandscape != UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            updateCollectionViewLayout()
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        updateCollectionViewLayout()
    }
}

// MARK: Extension - SearchTerm Delegate

extension PhotoWallViewController: SearchTermDelegate {
    func searchTermDidChange(sender: SearchTermTableViewController, newTerm: String) {
        if newTerm != self.searchTerm {
            self.searchTerm = newTerm
            self.page = 1
            self.getPhotos(resetPhotos: true, completionHandler: { 
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            })
        }
    }
}

