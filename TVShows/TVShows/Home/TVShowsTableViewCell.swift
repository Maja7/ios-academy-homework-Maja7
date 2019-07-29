//
//  TVShowsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Kingfisher

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
        //thumbnail.image = UIImage(named: item.imageUrl) ?? UIImage(named: "icImagePlaceholder")
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        if item.imageUrl.isEmpty {
            thumbnail.image = UIImage(named: "icImagePlaceholder")
        }else{
            thumbnail.kf.setImage(with: url)
        }
        title.text = item.title
    }
}

// MARK: - Private
private extension TVShowsTableViewCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 20
    }
}
