//
//  Tweet.swift
//  Twitter Clone
//
//  Created by Kazim Walji on 4/25/21.
//

import Foundation

struct Tweet: Codable, Hashable {
    let text: String
    let likes: Int
    let date:[String:Int]
}
