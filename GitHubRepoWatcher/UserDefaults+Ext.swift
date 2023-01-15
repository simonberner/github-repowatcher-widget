//
//  UserDefaults+Ext.swift
//  GitHubRepoWatcher
//
//  Created by Simon Berner on 08.01.23.
//

import Foundation

extension UserDefaults {

    /// Shared UserDefaults database with the AppGroup identifier: _group.dev.simonberner.RepoWatcher_
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.dev.simonberner.RepoWatcher")!
    }

    static let repoKey = "repos"
}

enum UserDefaultsError: Error {
    case retreival
}
