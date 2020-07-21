//
//  Repository.swift
//  GitHubClient
//
//  Created by Геннадий Махмудов on 18.07.2020.
//  Copyright © 2020 Геннадий Махмудов. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let name: String
    let description: String?
    let language: String?
}
