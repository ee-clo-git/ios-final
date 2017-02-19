//
//  VIPRewardCell.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

class VIPRewardCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
    }

    func set(item: VIPExperience) {
        label.text = item.name
        if let imageUrl = item.imageUrl {
            self.imageView.kf.setImage(with: URL(string: imageUrl)!)
        }
    }
}
