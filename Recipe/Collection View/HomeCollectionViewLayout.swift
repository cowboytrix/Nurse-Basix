//
//  HomeCollectionViewLayout.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

class HomeCollectionViewLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)
        let width = self.collectionView?.frame.width
        var frame = CGRect.zero

        if let unwrappedWidth = width {
            switch indexPath.row {
            case 0:
                frame.size = CGSize(width: unwrappedWidth, height: 200)
                break
            default:
                frame.size = CGSize(width: (unwrappedWidth/2) - 5, height: 120);
                break;
            }
        }

        currentItemAttributes!.frame = frame
        currentItemAttributes!.size = frame.size
        return currentItemAttributes
    }
}
