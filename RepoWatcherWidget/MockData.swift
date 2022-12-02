//
//  MockData.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 02.12.22.
//

import Foundation

struct MockData {
    // mock data object
    static let repoOne = Repository(name: "Repository 1",
                                       owner: Owner(avatarUrl: ""),
                                       hasIssues: true,
                                       forks: 66,
                                       watchers: 250,
                                       openIssues: 88,
                                       pushedAt: "2022-10-27T19:00:59Z",
                                        avatarData: Data())

    // mock data object
    static let repoTwo = Repository(name: "Repository 2",
                                       owner: Owner(avatarUrl: ""),
                                       hasIssues: false,
                                       forks: 199,
                                       watchers: 856,
                                       openIssues: 26,
                                       pushedAt: "2022-01-27T19:00:59Z",
                                        avatarData: Data())
}
