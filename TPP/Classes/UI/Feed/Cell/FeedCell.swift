//
//  FeedCell.swift
//  TPP
//
//  Created by Mihails Tumkins on 12/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell, Reusable {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet weak var roundedCornersView: UIView!
    @IBOutlet weak var iconImage: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bubble: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        roundedCornersView.layer.cornerRadius = 8.0
    }

    func configure(with item: FeedItem) {
        roundedCornersView.backgroundColor = item.color
        bubble.tintColor = item.color
        iconImage.image = item.type?.image

        titleLabel.text = item.title
        //descriptionLabel.text = item.description
        dateLabel.text = item.date == nil ? "" : "Due: " + FeedCell.dateFormatter.string(from:item.date!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }

}
