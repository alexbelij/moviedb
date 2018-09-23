//
//  DataStruct.swift
//  moviedb
//
//  Created by Matic on 15/09/2018.
//  Copyright © 2018 Matic. All rights reserved.
//


struct TVDetailsStruct: Codable {
    let created_by : [createdBy]
}

struct createdBy : Codable {
    let name : String
    let profile_path : String?
}





