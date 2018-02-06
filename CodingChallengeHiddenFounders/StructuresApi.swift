//
//  StructuresApi.swift
//  CodingChallengeHiddenFounders
//
//  Created by Gotzon Zabala on 4/2/18.
//  Copyright © 2018 Gotzon Zabala. All rights reserved.
//


struct GitHubDescription: Decodable {
    let items: [GitHub]
}

struct Owner: Decodable {
    let login: String
    let avatar_url: String
}

struct GitHub: Decodable {
    let name: String
    let owner: Owner
    let description: String?
    let stargazers_count: Float
}
