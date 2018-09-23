//
//  JSONStruct.swift
//  moviedb
//
//  Created by Matic on 06/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//


struct MovieDataStruct: Codable {
    var results: [BasicMovieInfo]
}

struct BasicMovieInfo: Codable {
    let id: Int
    let title: String
    let poster_path : String
    let genre_ids: [Int]
    let release_date : String
    let overview : String
}
