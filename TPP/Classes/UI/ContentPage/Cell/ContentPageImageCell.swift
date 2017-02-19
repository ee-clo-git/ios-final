//
//  ContentPageImageCell.swift
//  TPP
//
//  Created by Mihails Tumkins on 16/01/17.
//  Copyright © 2017 Chili. All rights reserved.
//

import UIKit
import Kingfisher

protocol ContentImageDownloadDelegate: class {
    func didDownload(image: UIImage)
    func onError(error: Error)
}

class ContentPageImageCell: UICollectionViewCell, Reusable {

    weak var delegate: ContentImageDownloadDelegate?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    func configure(with model: String?) {
        guard let url = model else { return }
        self.imageView.image = nil
        //if model.type == .photo {
            self.loader.startAnimating()
            self.imageView.kf.setImage(with: URL(string: url)!, placeholder: nil, completionHandler: {[weak self] (image, error, cacheType, anUrl) in
                if let error = error {
                    self?.delegate?.onError(error: error)
                } else if let image = image {
                    self?.delegate?.didDownload(image: image)
                }
                self?.loader.stopAnimating()
            })
        //}

    }
}
