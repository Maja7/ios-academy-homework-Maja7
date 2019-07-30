//
//  NewEpisode.swift
//  TVShows
//
//  Created by Infinum on 26/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct NewEpisode : Codable {
    let showId : String
    let mediaId : String
    let title : String
    let description : String
    let episodeNumber : String
    let seasonNumber : String
}
