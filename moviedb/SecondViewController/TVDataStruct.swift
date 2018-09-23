//
//  TVDataStruct.swift
//  moviedb
//
//  Created by Matic on 15/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//

import Foundation

struct TVDataStruct: Codable {
    let results: [Result]
}

struct Result: Codable {
    let original_name: String
    let genre_ids: [Int]
    let name: String
    let popularity: Double
    let first_air_date: String
    let id: Int
    let overview, poster_path: String
}
