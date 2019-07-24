//
//  TVShowItem.swift
//  TVShows
//
//  Created by Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct TVShowItem : Codable{
    let id : String
    let title : String
    let imageUrl : String
    let likesCount : NSInteger
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}
