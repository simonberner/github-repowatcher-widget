//
//  Repository.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 28.11.22.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String

}

struct Owner: Decodable {
    let avatarUrl: String
}
