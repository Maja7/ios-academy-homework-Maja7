//
//  TVShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class TVShowsTableViewCell: UITableViewCell {
    
    // MARK: - Private UI
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
        title.text = nil
    }
    
}

// MARK: - Configure
extension TVShowsTableViewCell {
    func configure(with item: TVShowItem) {
        // Here we are using conditional unwrap, meaning if we have the image, use that, if not, fallback to placeholder image.
        //thumbnail.image = UIImage(named: item.imageUrl)
        title.text = item.title
    }
}

// MARK: - Private
private extension TVShowsTableViewCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 20
    }
}
