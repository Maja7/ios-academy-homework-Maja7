//
//  ShowDetails.swift
//  TVShows
//
//  Created by Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct ShowDetails : Codable {
    let type : String
    let title : String
    let description : String
    let id : String
    let likesCount : NSInteger
    let imageUrl : String
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case id = "_id"
        case likesCount
        case imageUrl
    }
}

struct ShowEpisode : Codable{
    let id : String
    let title : String
    let description : String
    let imageUrl : String
    let episodeNumber : String
    let season : String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}
