//
//  GridFlowLayout.swift
//  buttsssbook
//
//  Created by Mateus Rodrigues on 20/05/20.
//  Copyright © 2020 Mateus Rodrigues. All rights reserved.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
    
    private var numberOfColumns: CGFloat
    
    private var spacing: CGFloat
    
    private var side: CGFloat {
        let interitemSpacesCount = numberOfColumns - 1
        let interitemSpacingPerRow = minimumInteritemSpacing * interitemSpacesCount
        let rowContentWidth = collectionView!.frame.width - 2*spacing - interitemSpacingPerRow
        return rowContentWidth / numberOfColumns
    }
    
    init(numberOfColumns: Int = 3, spacing: CGFloat = 0) {
        self.numberOfColumns = CGFloat(numberOfColumns)
        self.spacing = spacing
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        self.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        self.itemSize = CGSize(width: side, height: side)
    }
    
}

