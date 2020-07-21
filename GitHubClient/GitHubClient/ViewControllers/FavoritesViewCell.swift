//
//  FavoritesViewCell.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 19.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import UIKit

class FavoritesViewCell: UICollectionViewCell {
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            return layoutAttributes
    }
}
