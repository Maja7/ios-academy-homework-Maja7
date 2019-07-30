//
//  EpizodeDetailsTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class EpisodeDetailsTableViewCell: UITableViewCell {

    // MARK: - Private UI
    
    @IBOutlet weak var season: UILabel!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        season.text = nil
        episodeNumber.text = nil
        title.text = nil
    }
    
}

// MARK: - Configure
extension EpisodeDetailsTableViewCell {
    func configure(with item: ShowEpisode) {
        title.text = item.title
        episodeNumber.text = "Ep" + item.episodeNumber
        season.text = "S" + item.season
    }
}


