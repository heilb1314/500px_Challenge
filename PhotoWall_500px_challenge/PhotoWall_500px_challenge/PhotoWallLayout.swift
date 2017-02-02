//
//  PhotoWallLayout.swift
//  demo_500px
//
//  Created by Jianxiong Wang on 2/1/17.
//  Copyright © 2017 JianxiongWang. All rights reserved.
//

import UIKit

protocol PhotoWallLayoutDelegate {    
    func collectionView(collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

class PhotoWallLayout: UICollectionViewLayout {
    
    var delegate:PhotoWallLayoutDelegate!
    
    var layoutVertical:Bool = true
    var doubleCellProbability:Int = 5 // between 0 and 10
    var columnsCount: Int = 3
    var columnWidth: CGFloat = 0
    var cellPadding: CGFloat = 1.0
    
    var columnOffsets: [CGFloat]!
    private var itemAttributes = [UICollectionViewLayoutAttributes]()

    private func findShortestColumn() -> Int {
        return columnOffsets.index(of: columnOffsets.min()!)!
    }
    
    private func findLongestColumn() -> Int {
        return columnOffsets.index(of: columnOffsets.max()!)!
    }
    
    private func canDoubleCellWidth(at index: Int, with indexPath: IndexPath) -> Bool {
        // return True if column i and i+1 have same offset and remainder less than probability
        if !layoutVertical {
            // avoid long horizontal image 
            let size = delegate.collectionView(collectionView: self.collectionView!, sizeForPhotoAtIndexPath: indexPath)
            if size.width / size.height > 2 { return false }
        }
        return (index < self.columnsCount - 1) && self.columnOffsets[index] == self.columnOffsets[index+1] && indexPath.item % 10 < doubleCellProbability
    }
    
    private func setColumnWidth() {
        self.columnWidth = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? round(self.collectionView!.bounds.size.height / CGFloat(self.columnsCount)) : round(self.collectionView!.bounds.size.width / CGFloat(self.columnsCount))
    }
    
    override func prepare() {
        setColumnWidth()
        guard let itemCounts = self.collectionView?.numberOfItems(inSection: 0) else { return }
        layoutVertical = !UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        columnOffsets = [CGFloat].init(repeating: 0, count: columnsCount)
        
        
        for i in 0..<itemCounts {
            // get shortest column offsets
            let shortestIndex = self.findShortestColumn()
            let x0 = layoutVertical ? shortestIndex * Int(self.columnWidth) : Int(self.columnOffsets[shortestIndex])
            let y0 = layoutVertical ? Int(self.columnOffsets[shortestIndex]) : shortestIndex * Int(self.columnWidth)
            
            let indexPath = IndexPath(item: i, section: 0)
            
            // calculate item width and height
            let itemSize = delegate.collectionView(collectionView: self.collectionView!, sizeForPhotoAtIndexPath: indexPath)
            var width = (canDoubleCellWidth(at: shortestIndex, with: indexPath) ? 2 * columnWidth : columnWidth)
            var height = round(layoutVertical ? width/itemSize.width*itemSize.height : width/itemSize.height*itemSize.width)
            
            if !layoutVertical {
                swap(&width, &height)
                // increase column collapse possibility
                width += width / height < 1 ? CGFloat(40 - (Int(width) % 40)) : -CGFloat(Int(width) % 40)
                // update offset
                columnOffsets[shortestIndex] = CGFloat(x0) + width
                if height > columnWidth {
                    columnOffsets[shortestIndex+1] = CGFloat(x0) + width
                }
            } else {
                // increase column collapse possibility
                height += height / width < 1 ? CGFloat(40 - (Int(height) % 40)) : -CGFloat(Int(height) % 40)
                columnOffsets[shortestIndex] = CGFloat(y0) + height
                if width > columnWidth {
                    columnOffsets[shortestIndex+1] = CGFloat(y0) + height
                }
            }
            
            // add attributes to itemAttributes array
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: CGFloat(x0), y: CGFloat(y0), width: width, height: height).insetBy(dx: cellPadding, dy: cellPadding)
            self.itemAttributes.append(attributes)
            
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.itemAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < self.itemAttributes.count else { return nil }
        return self.itemAttributes[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            guard var size = self.collectionView?.bounds.size else { return CGSize.zero }
            let longestIndex = self.findLongestColumn()
            let columnMax = self.columnOffsets[longestIndex]
            if layoutVertical {
                size.height = columnMax
            } else {
                size.width = columnMax
            }
            
            return size
        }
    }
    
}
