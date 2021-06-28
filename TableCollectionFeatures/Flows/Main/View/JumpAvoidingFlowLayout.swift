//
//  JumpAvoidingFlowLayout.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 29.06.2021.
//

import UIKit

class JumpAvoidingFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        let targetX: CGFloat = {
            let totalWidth = collectionViewContentSize.width + collectionView.contentInset.horizontal
            
            if totalWidth > collectionView.bounds.size.width {
                return proposedContentOffset.x
            }

            return 0
        }()

        let targetY: CGFloat = {
            let totalHeight = collectionViewContentSize.height + collectionView.contentInset.vertical
            
            if totalHeight > collectionView.bounds.size.height {
                return proposedContentOffset.y
            }
            
            return 0
        }()

        return CGPoint(x: targetX, y: targetY)
    }

}
