//
//  CashCardsCell.swift
//  TPP
//
//  Created by Igors Nemenonoks on 23/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Kingfisher

class CashCardsCell: UICollectionViewCell, Reusable {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    private lazy var shadowLayer: CALayer = {
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = self.imageView.frame
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowLayer.shadowRadius = 8
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowPath = UIBezierPath(roundedRect: self.imageView.bounds, cornerRadius: 3).cgPath
        self.layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 3
    }

    func set(item: RewardDO) {
        label.text = item.brandName
        if let imageUrl = item.smallImageUrl, let url = URL(string: imageUrl) {
            self.imageView.kf.setImage(with: url)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.imageView.frame.height)
        self.shadowLayer.shadowPath = UIBezierPath(roundedRect: self.shadowLayer.frame, cornerRadius: 3).cgPath
    }
}
