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

    // mock data object
    static let placeholder = Repository(name: "Your Repo",
                                       owner: Owner(avatarUrl: ""),
                                       hasIssues: true,
                                       forks: 66,
                                       watchers: 250,
                                       openIssues: 88,
                                       pushedAt: "2022-10-27T19:00:59Z")

}

struct Owner: Decodable {
    let avatarUrl: String
}
