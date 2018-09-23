//
//  Codable Struct.swift
//  moviedb
//
//  Created by Matic on 08/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//


// these two structs are used in func getMovieCredits() in MovieDetailsViewController.swift
struct MovieCast: Codable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Codable {
    let cast_id: Int
    let character, credit_id: String
    let gender, id: Int
    let name: String
    let order: Int
    let profile_path: String?
}

// Struct used in func getMovieDetails() to get various movie details used in MovieDetailsViewController.swift
struct MovieDetails: Codable {
    let genres: [Genres]
    let runtime : Int
    let tagline : String
}

struct Genres : Codable {
    let name : String
}



