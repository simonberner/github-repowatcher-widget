//
//  Repository.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 28.11.22.
//

import Foundation

struct Repository {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    var avatarData: Data // Attaching the avatar image data to the (json) repository model
    var contributors: [Contributor] = [] // initialized with an empty array
}

// With that extension we can make that type use the same structure as our JSON does,
// without affecting our actual model code.
extension Repository {
    // Conforms to the JSON structure and used to decode the JSON into an object
    // This is the JSON prison ;)
    struct CodingData: Decodable {
        let name: String
        let owner: Owner
        let hasIssues: Bool
        let forks: Int
        let watchers: Int
        let openIssues: Int
        let pushedAt: String

        // a computed property which consist of a decoded repository data object
        // and some additional data
        var repo :Repository {
            Repository(name: name,
                       owner: owner,
                       hasIssues: hasIssues,
                       forks: forks,
                       watchers: watchers,
                       openIssues: openIssues,
                       pushedAt: pushedAt,
                       avatarData: Data())
        }
    }
}

struct Owner: Decodable {
    let avatarUrl: String
}
